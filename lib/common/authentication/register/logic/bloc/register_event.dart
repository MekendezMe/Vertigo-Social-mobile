part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class Register extends RegisterEvent {
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
