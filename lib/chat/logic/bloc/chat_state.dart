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
  final List<Message> messages;
  final Chat chat;
  final bool lastPage;
  final bool isLoadingMore;
  final int currentPage;
  final User user;

  ChatLoaded({
    required this.messages,
    required this.lastPage,
    required this.user,
    required this.chat,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });
  @override
  List<Object?> get props => [
    messages,
    lastPage,
    user,
    chat,
    isLoadingMore,
    currentPage,
  ];

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isLoadingMore,
    bool? lastPage,
    int? currentPage,
    User? user,
    Chat? chat,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isLoadingMore: isLoadingMore ?? false,
      lastPage: lastPage ?? false,
      currentPage: currentPage ?? this.currentPage,
      user: user ?? this.user,
      chat: chat ?? this.chat,
    );
  }
}

class ChatLoadingFailure extends ChatState {
  final Object? error;

  ChatLoadingFailure({this.error});
  @override
  List<Object?> get props => [error];
}
