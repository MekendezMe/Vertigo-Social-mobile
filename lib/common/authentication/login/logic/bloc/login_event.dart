part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class Authorize extends LoginEvent {
  @override
  List<Object?> get props => [];
}
