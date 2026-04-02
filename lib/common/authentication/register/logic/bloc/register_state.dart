part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {}

class RegisterInitial extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterFailure extends RegisterState {
  final Object? error;

  RegisterFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class Registering extends RegisterState {
  @override
  List<Object?> get props => [];
}
