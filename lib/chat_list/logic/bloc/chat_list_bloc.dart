import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';
import 'package:social_network_flutter/chat_list/logic/entities/request/get_chats_request.dart';
import 'package:social_network_flutter/chat_list/logic/repository/chat_list_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatListRepository chatListRepository;
  final Talker talker;
  final ErrorHandler errorHandler;
  final UserService userService;
  ChatListBloc({
    required this.chatListRepository,
    required this.talker,
    required this.errorHandler,
    required this.userService,
  }) : super(ChatListInitial()) {
    on<LoadChats>(_loadChats);
    on<LoadMoreChats>(_onLoadMoreChats);
  }

  Future<void> _loadChats(LoadChats event, Emitter<ChatListState> emit) async {
    try {
      emit(ChatsLoading());
      final response = await chatListRepository.getChats(
        GetChatsRequest(pageNumber: event.pageNumber ?? 1),
      );
      final user = userService.currentUser;
      if (user == null) {
        throw AuthException();
      }
      emit(
        ChatsLoaded(
          chats: response.chats,
          lastPage: response.lastPage,
          user: user,
        ),
      );
    } catch (e, st) {
      emit(ChatsLoadingFailure(error: e));
      errorHandler.handle(e);
      talker.handle(e, st);
    }
  }

  Future<void> _onLoadMoreChats(
    LoadMoreChats event,
    Emitter<ChatListState> emit,
  ) async {
    if (state is! ChatsLoaded) return;
    final current = state as ChatsLoaded;
    try {
      emit(current.copyWith(isLoadingMore: true));
      final response = await chatListRepository.getChats(
        GetChatsRequest(pageNumber: event.pageNumber),
      );
      emit(
        current.copyWith(
          isLoadingMore: false,
          chats: [...current.chats, ...response.chats],
          currentPage: event.pageNumber,
          lastPage: response.lastPage,
        ),
      );
    } catch (e, st) {
      emit(current.copyWith(isLoadingMore: false, lastPage: true));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }
}
