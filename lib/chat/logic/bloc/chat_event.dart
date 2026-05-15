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

class LoadPrevChat extends ChatEvent {
  final int pageNumber;
  final int chatId;

  LoadPrevChat({required this.pageNumber, required this.chatId});
  @override
  List<Object?> get props => [pageNumber, chatId];
}

class CreateMessage extends ChatEvent {
  final int chatId;
  final int senderId;
  final String? type;
  final String? content;
  final int? replyId;
  final int? postId;
  final List<File>? media;
  final List<int>? forwardedMessageIds;

  CreateMessage({
    required this.chatId,
    required this.senderId,
    this.type,
    this.content,
    this.replyId,
    this.postId,
    this.media,
    this.forwardedMessageIds,
  });

  @override
  List<Object?> get props => [
    chatId,
    senderId,
    type,
    content,
    replyId,
    postId,
    media,
    forwardedMessageIds,
  ];
}
