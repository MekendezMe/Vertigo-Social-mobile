part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final int userId;

  LoginSuccess({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class LoginFailure extends LoginState {
  final Object? error;

  LoginFailure({this.error});
  @override
  List<Object?> get props => [error];
}
