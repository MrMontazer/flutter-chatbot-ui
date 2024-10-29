import 'package:chatbot_ui/chat/bloc/chat_bloc.dart';
import 'package:chatbot_ui/chat/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(ChatHistoryLoaded()),
      child: ChatView(),
    );
  }
}
