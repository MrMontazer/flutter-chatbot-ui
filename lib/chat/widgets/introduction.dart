import 'package:chatbot_ui/chat/bloc/chat_bloc.dart';
import 'package:chatbot_ui/chat/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "What can i help with?",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  promptSuggest(context: context, text: "🎆 Create Image"),
                  promptSuggest(context: context, text: "💡 Make a plan"),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  promptSuggest(context: context, text: "🪶 Help me write"),
                  promptSuggest(context: context, text: "📊 Analyze data"),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget promptSuggest({required BuildContext context, required String text}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: () {
              var message = MessageModel(fromBot: false, text: text);
              context.read<ChatBloc>().add(ChatMessageSent(message));
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ),
      ),
    );
  }
}
