part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {}

class RegisterInitial extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends RegisterState {
  final int userId;
  final String? username;
  final String name;

  RegisterSuccess({required this.userId, required this.name, this.username});
  @override
  List<Object?> get props => [userId, username, name];
}

class RegisterFailure extends RegisterState {
  final Object? error;

  RegisterFailure({this.error});
  @override
  List<Object?> get props => [error];
}
