part of 'launcher_bloc.dart';

abstract class LauncherEvent extends Equatable {}

class Initialize extends LauncherEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends LauncherEvent {
  @override
  List<Object?> get props => [];
}

class LogoutRequested extends LauncherEvent {
  @override
  List<Object?> get props => [];
}
