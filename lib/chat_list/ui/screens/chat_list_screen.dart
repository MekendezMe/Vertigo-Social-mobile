import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/chat_list/logic/bloc/chat_list_bloc.dart';
import 'package:social_network_flutter/chat_list/ui/widgets/chat_item_widget.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';

class ChatListScreen extends StatefulWidget {
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context}) onShowMain;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context, required int chatId})
  onShowChat;
  const ChatListScreen({
    super.key,
    required this.chatListBloc,
    required this.onShowSettings,
    required this.onShowMain,
    required this.onShowProfile,
    required this.onShowChat,
  });
  final ChatListBloc chatListBloc;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.chatListBloc.add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: customDrawer(
          context: context,
          active: TypeScreen.messages,
          onShowSettings: () => widget.onShowSettings(context: context),
          onShowProfile: () => widget.onShowProfile(context: context),
          onShowChatList: null,
          onShowMain: () => widget.onShowMain(context: context),
        ),
      ),
      body: BlocConsumer<ChatListBloc, ChatListState>(
        bloc: widget.chatListBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatsLoaded) {
            return _buildLoadedContent(state);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildLoadedContent(ChatsLoaded state) {
    return CustomScrollView(
      controller: _scrollController,
      physics: state.chats.isEmpty
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (state.chats.isEmpty)
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
              final chat = state.chats[index];
              return GestureDetector(
                onTap: () =>
                    widget.onShowChat(context: context, chatId: chat.id),
                child: ChatItemWidget(chat: chat),
              );
            }, childCount: state.chats.length),
          ),
      ],
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final blocState = context.read<ChatListBloc>().state;

    if (blocState is! ChatsLoaded || blocState.isLoadingMore) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && !(blocState.lastPage)) {
      final nextPage = blocState.currentPage + 1;
      context.read<ChatListBloc>().add(LoadMoreChats(pageNumber: nextPage));
    }
  }
}
