import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/notifications/notification_service.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/request/save_token_request.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:social_network_flutter/common/launcher/logic/service/logout_service.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
import 'package:social_network_flutter/main.dart';
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
  final NotificationService notificationService;

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
    required this.notificationService,
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
      final String? deviceId = secureStorage.deviceId;
      if (secureStorage.refreshToken == null || deviceId == null) {
        add(LogoutRequested());
        return;
      } else {
        await preferencesStorage.load();
        final tokens = await launcherRepository.getTokens();
        if (!_hasAccess(tokens.accessToken)) {
          add(LogoutRequested());
          return;
        }
        secureStorage.refreshToken = tokens.refreshToken;
        await secureStorage.save();
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

  bool _hasAccess(String? accessToken) {
    return accessToken != null && accessToken.isNotEmpty;
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
      await _saveFcmToken();
      final String? pendingPayload = await notificationService
          .getPendingNotification();
      if (pendingPayload != null && pendingPayload.isNotEmpty) {
        handleNotificationNavigation(pendingPayload);
      }
      _login(emit);
    } catch (e, st) {
      talker.handle(e, st);
      errorHandler.handle(e);
      add(LogoutRequested());
    }
  }

  Future<void> _saveFcmToken() async {
    final token = preferencesStorage.fcmToken;
    if (token == null) {
      return;
    }
    try {
      await launcherRepository.saveToken(SaveTokenRequest(fcmToken: token));
    } catch (e) {
      return;
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
      await preferencesStorage.clear();
      _logout(emit);
    } catch (e, st) {
      talker.handle(e, st);
      _logout(emit);
    }
  }
}
