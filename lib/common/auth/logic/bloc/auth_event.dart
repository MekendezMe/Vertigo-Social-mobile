part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class Authorize extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class Register extends AuthEvent {
  final String name;
  final String? username;
  final String email;
  final String password;
  Register({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [name, username, email, password];
}
