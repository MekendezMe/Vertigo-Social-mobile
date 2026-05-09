import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/chat/logic/entities/request/get_messages_request.dart';
import 'package:social_network_flutter/chat/logic/repository/chat_repository.dart';
import 'package:social_network_flutter/chat_list/logic/entities/chat.dart';
import 'package:social_network_flutter/chat_list/logic/entities/message.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:talker_flutter/talker_flutter.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final Talker talker;
  final ErrorHandler errorHandler;
  final UserService userService;
  ChatBloc({
    required this.chatRepository,
    required this.talker,
    required this.errorHandler,
    required this.userService,
  }) : super(ChatInitial()) {
    on<LoadChat>(_onLoadChat);
    on<LoadMoreChat>(_onLoadMoreChat);
  }

  Future<void> _onLoadChat(LoadChat event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      final response = await chatRepository.getMessages(
        GetMessagesRequest(
          chatId: event.chatId,
          pageNumber: event.pageNumber ?? 1,
        ),
      );
      final user = userService.currentUser;
      if (user == null) {
        throw AuthException();
      }
      emit(
        ChatLoaded(
          messages: response.messages,
          lastPage: response.lastPage,
          user: user,
          chat: response.chat,
        ),
      );
    } catch (e, st) {
      emit(ChatLoadingFailure(error: e));
      errorHandler.handle(e);
      talker.handle(e, st);
    }
  }

  Future<void> _onLoadMoreChat(
    LoadMoreChat event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;
    final current = state as ChatLoaded;
    try {
      emit(current.copyWith(isLoadingMore: true));
      final response = await chatRepository.getMessages(
        GetMessagesRequest(pageNumber: event.pageNumber, chatId: event.chatId),
      );
      emit(
        current.copyWith(
          isLoadingMore: false,
          messages: [...current.messages, ...response.messages],
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
