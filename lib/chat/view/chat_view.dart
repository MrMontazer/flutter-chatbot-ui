import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:chatbot_ui/chat/bloc/chat_bloc.dart';
import 'package:chatbot_ui/chat/widgets/introduction.dart';
import 'package:chatbot_ui/chat/widgets/message_bubble.dart';
import 'package:chatbot_ui/chat/widgets/message_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final ScrollController scrollController = ScrollController();
  final scrollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool autoScroll = false;

    scrollController.addListener(() {
      double diff = scrollController.position.maxScrollExtent - scrollController.offset;

      if (diff == 0) {
        autoScroll = true;
      } else if (scrollController.position.userScrollDirection != ScrollDirection.idle){
        autoScroll = false;
      }
    });

    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ChatBot UI"),
          centerTitle: true,
          actions: [
            ThemeSwitcher.withTheme(
              builder: (context, switcher, theme) {
                bool isDarkMode = theme.brightness == Brightness.dark;
                return IconButton(
                  onPressed: () => switcher.changeTheme(theme: isDarkMode? ThemeData.light() : ThemeData.dark()),
                  icon: Icon(isDarkMode? Icons.light_mode_rounded: Icons.dark_mode_rounded)
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  var bloc = context.read<ChatBloc>();
      
                  if (state is ChatInitial || state is ChatLoadInProgress){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (state is ChatMessagesUpdated) {
                    if (state.event == MessageUpdateEvent.newMessageFromUser) autoScroll = true;
      
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients && autoScroll) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: 300.ms,
                          curve: Curves.easeOut
                        );
                      }
                    });
                  }
                  else if (state is ChatTypingInProgress && autoScroll) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    });
                  }
      
                  if (bloc.messages.isEmpty) return const Center(child: Introduction());
      
                  return SingleChildScrollView(
                    key: scrollKey,
                    controller: scrollController,
                    child: SelectionArea(
                      child: Column(
                        children: bloc.messages
                                  .map((message) => MessageBubble(message: message))
                                  .toList()
                      ),
                    ),
                  );
                },
              ),
            ),
            const MessageComposer()
          ],
        ),
      ),
    );
  }
}