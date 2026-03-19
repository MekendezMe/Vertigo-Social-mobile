part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthorizeLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthorizeLoadingSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthorizeSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthorizeFailure extends AuthState {
  final Object? error;

  AuthorizeFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class RegisterLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterLoadingSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterFailure extends AuthState {
  final Object? error;

  RegisterFailure({this.error});
  @override
  List<Object?> get props => [error];
}
