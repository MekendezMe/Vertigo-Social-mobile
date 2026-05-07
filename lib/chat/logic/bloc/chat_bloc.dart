import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/chat/logic/repository/chat_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
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
    on<LoadChat>(_loadChat);
  }

  Future<void> _loadChat(LoadChat event, Emitter<ChatState> emit) async {
    throw Exception();
  }
}
