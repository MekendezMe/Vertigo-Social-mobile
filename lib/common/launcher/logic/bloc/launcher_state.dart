part of 'launcher_bloc.dart';

abstract class LauncherState extends Equatable {}

class LauncherInitial extends LauncherState {
  @override
  List<Object?> get props => [];
}

class LauncherLoading extends LauncherState {
  @override
  List<Object?> get props => [];
}

class LauncherLoggedOutInitial extends LauncherState {
  @override
  List<Object> get props => [];
}

class LauncherLoggedInInitial extends LauncherState {
  @override
  List<Object> get props => [];
}

class LauncherLoggedIn extends LauncherState {
  @override
  List<Object> get props => [];
}

class LauncherLoggedOut extends LauncherState {
  @override
  List<Object> get props => [];
}
