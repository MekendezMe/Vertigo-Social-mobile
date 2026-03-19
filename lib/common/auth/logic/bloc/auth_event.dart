part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class Authorize extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class Register extends AuthEvent {
  @override
  List<Object?> get props => [];
}
