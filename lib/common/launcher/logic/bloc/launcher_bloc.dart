import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:social_network_flutter/common/launcher/logic/service/logout_service.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
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
  final UserService userService;
  final ErrorHandler errorHandler;
  final PermissionService permissionService;

  late final StreamSubscription _logoutSub;

  LauncherBloc({
    required this.secureStorage,
    required this.preferencesStorage,
    required this.tokenService,
    required this.launcherRepository,
    required this.talker,
    required this.logoutService,
    required this.userService,
    required this.errorHandler,
    required this.permissionService,
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
        add(LogoutRequested());
        return;
      } else {
        await preferencesStorage.load();
        final tokens = await launcherRepository.getTokens();
        final String? deviceId = secureStorage.deviceId;
        if (!_hasAccess(deviceId, tokens.accessToken)) {
          add(LogoutRequested());
          return;
        }
        secureStorage.refreshToken = tokens.refreshToken;
        secureStorage.save();
        tokenService.setToken(tokens.accessToken);
        add(LoginRequested());
      }
    } catch (e, st) {
      talker.handle(e, st);
      errorHandler.handle(e);
      add(LogoutRequested());
    }
  }

  Future<void> _logout(Emitter<LauncherState> emit) async {
    emit(LauncherLoggedOut());
  }

  bool _hasAccess(String? deviceId, String? accessToken) {
    return accessToken != null &&
        accessToken.isNotEmpty &&
        deviceId != null &&
        deviceId.isNotEmpty;
  }

  Future<void> _login(Emitter<LauncherState> emit) async {
    emit(LauncherLoggedIn());
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<LauncherState> emit,
  ) async {
    try {
      await userService.loadCurrentUser();
      _login(emit);
      final status = await permissionService.requestNotificationIfNeeded();
    } catch (e, st) {
      talker.handle(e, st);
      errorHandler.handle(e);
      add(LogoutRequested());
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<LauncherState> emit,
  ) async {
    try {
      if (secureStorage.deviceId != null &&
          secureStorage.deviceId!.isNotEmpty) {
        await launcherRepository.logout();
      }
      userService.clear();
      await secureStorage.clear();
      await secureStorage.save();
      await preferencesStorage.clear();
      _logout(emit);
    } catch (e, st) {
      talker.handle(e, st);
      errorHandler.handle(e);
      _logout(emit);
    }
  }
}
