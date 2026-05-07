part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {}

class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoaded extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoadingFailure extends ChatState {
  final Object? error;

  ChatLoadingFailure({this.error});
  @override
  List<Object?> get props => [error];
}
