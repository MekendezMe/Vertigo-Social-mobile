import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:social_network_flutter/common/launcher/logic/service/logout_service.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'launcher_event.dart';
part 'launcher_state.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  final ISecureStorage secureStorage;
  final IPreferencesStorage preferencesStorage;
  final TokenService tokenService;
  final LauncherRepository launcherRepository;
  final Talker talker;
  final LogoutService logoutService;

  late final StreamSubscription _logoutSub;

  LauncherBloc({
    required this.secureStorage,
    required this.preferencesStorage,
    required this.tokenService,
    required this.launcherRepository,
    required this.talker,
    required this.logoutService,
  }) : super(LauncherInitial()) {
    on<Initialize>(_onInitialize);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    _logoutSub = logoutService.stream.listen((_) {
      add(LogoutRequested());
    });
  }

  @override
  Future<void> close() {
    _logoutSub.cancel();
    return super.close();
  }

  Future<void> _onInitialize(
    Initialize event,
    Emitter<LauncherState> emit,
  ) async {
    try {
      await secureStorage.load();
      if (secureStorage.refreshToken == null) {
        logout(emit);
      } else {
        await preferencesStorage.load();
        final String accessToken = await launcherRepository.getAccessToken();
        final String? deviceId = secureStorage.deviceId;
        if (!_hasAccess(deviceId, accessToken)) {
          logout(emit);
        }
        tokenService.setToken(accessToken);
        emit(LauncherLoggedIn());
      }
    } catch (e, st) {
      talker.handle(e, st);
      emit(LauncherLoggedOut());
    }
  }

  Future<void> logout(Emitter<LauncherState> emit) async {
    emit(LauncherLoggedOut());
  }

  bool _hasAccess(String? deviceId, String? accessToken) {
    return accessToken != null &&
        accessToken.isNotEmpty &&
        deviceId != null &&
        deviceId.isNotEmpty;
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<LauncherState> emit,
  ) async {
    await secureStorage.load();
    await preferencesStorage.load();
    emit(LauncherLoggedIn());
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<LauncherState> emit,
  ) async {
    await secureStorage.clear();
    emit(LauncherLoggedOut());
  }
}
