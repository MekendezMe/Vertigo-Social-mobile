part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {}

class LoadChat extends ChatEvent {
  final int? pageNumber;
  final int chatId;

  LoadChat({this.pageNumber, required this.chatId});
  @override
  List<Object?> get props => [pageNumber, chatId];
}

class LoadMoreChat extends ChatEvent {
  final int pageNumber;
  final int chatId;

  LoadMoreChat({required this.pageNumber, required this.chatId});
  @override
  List<Object?> get props => [pageNumber, chatId];
}
