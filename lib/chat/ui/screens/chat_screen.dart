import 'package:flutter/material.dart';
import 'package:social_network_flutter/chat/logic/bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId, required this.chatBloc});
  final int chatId;
  final ChatBloc chatBloc;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
