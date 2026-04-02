part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class Register extends RegisterEvent {
  final String username;
  final String? name;

  final String email;
  final String password;
  Register({
    required this.username,
    this.name,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [name, username, email, password];
}
