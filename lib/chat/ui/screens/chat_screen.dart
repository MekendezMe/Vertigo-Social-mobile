import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/chat/logic/bloc/chat_bloc.dart';
import 'package:social_network_flutter/chat/ui/widgets/create_message_widget.dart';
import 'package:social_network_flutter/chat/ui/widgets/header_widget.dart';
import 'package:social_network_flutter/chat/ui/widgets/message_item_widget.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId, required this.chatBloc});
  final int chatId;
  final ChatBloc chatBloc;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.chatBloc.add(LoadChat(chatId: widget.chatId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: widget.chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatLoaded) {
            return _buildChatLoadedContent(state);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildChatLoadedContent(ChatLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        HeaderWidget(chat: state.chat),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            reverse: true,
            physics: state.messages.isEmpty
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (state.messages.isEmpty)
                SliverFillRemaining(
                  child: Container(
                    padding: EdgeInsets.only(top: 14),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Icon(
                            Icons.chat_bubble,
                            size: 48,
                            color: context.color.gray,
                          ),
                          Text(
                            'Чатов нет',
                            style: context.theme.textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final message = state.messages[index];
                    return GestureDetector(
                      onTap: () {},
                      child: MessageItemWidget(
                        message: message,
                        user: state.user,
                      ),
                    );
                  }, childCount: state.messages.length),
                ),
            ],
          ),
        ),
        SizedBox(height: 5),
        CreateMessageWidget(
          onSendMessage: ({String? type, required String content}) =>
              _sendMessage(
                chatId: state.chat.id,
                senderId: state.user.id,
                type: type,
                content: content,
              ),
        ),
      ],
    );
  }

  void _sendMessage({
    required int chatId,
    required int senderId,
    String? type,
    required String content,
  }) {
    widget.chatBloc.add(
      CreateMessage(
        chatId: chatId,
        senderId: senderId,
        type: type,
        content: content,
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final blocState = widget.chatBloc.state;

    if (blocState is! ChatLoaded || blocState.isLoadingMore) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final min = _scrollController.position.minScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200) {
      widget.chatBloc.add(
        LoadPrevChat(
          pageNumber: blocState.currentPage + 1,
          chatId: blocState.chat.id,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
