import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';

part 'launcher_event.dart';
part 'launcher_state.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  LauncherBloc({required this.secureStorage, required this.preferencesStorage})
    : super(LauncherInitial()) {
    on<Initialize>(_onInitialize);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onInitialize(
    Initialize event,
    Emitter<LauncherState> emit,
  ) async {
    await secureStorage.load();
    if (secureStorage.refreshToken == null) {
      emit(LauncherLoggedOut());
    } else {
      await preferencesStorage.load();
      emit(LauncherLoggedIn());
    }
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

  final ISecureStorage secureStorage;
  final IPreferencesStorage preferencesStorage;
}
