part of 'chat_list_bloc.dart';

abstract class ChatListState extends Equatable {}

class ChatListInitial extends ChatListState {
  @override
  List<Object?> get props => [];
}

class ChatsLoading extends ChatListState {
  @override
  List<Object?> get props => [];
}

class ChatsLoaded extends ChatListState {
  final List<Chat> chats;
  final bool lastPage;
  final bool isLoadingMore;
  final int currentPage;

  ChatsLoaded({
    required this.chats,
    required this.lastPage,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });
  @override
  List<Object?> get props => [chats, lastPage, isLoadingMore, currentPage];

  ChatsLoaded copyWith({
    List<Chat>? chats,
    bool? isLoadingMore,
    bool? lastPage,
    int? currentPage,
  }) {
    return ChatsLoaded(
      chats: chats ?? this.chats,
      isLoadingMore: isLoadingMore ?? false,
      lastPage: lastPage ?? false,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ChatsLoadingFailure extends ChatListState {
  final Object? error;

  ChatsLoadingFailure({this.error});
  @override
  List<Object?> get props => [error];
}
