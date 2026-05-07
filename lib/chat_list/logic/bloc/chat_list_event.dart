part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {}

class LoadChats extends ChatListEvent {
  final int? pageNumber;

  LoadChats({this.pageNumber});
  @override
  List<Object?> get props => [pageNumber];
}

class LoadMoreChats extends ChatListEvent {
  final int pageNumber;

  LoadMoreChats({required this.pageNumber});
  @override
  List<Object?> get props => [pageNumber];
}
