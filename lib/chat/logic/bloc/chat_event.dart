part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {}

class LoadChat extends ChatEvent {
  @override
  List<Object?> get props => [];
}
