import 'package:chatbot_ui/chat/models/message_model.dart';
import 'package:chatbot_ui/chat/widgets/media_viewer.dart';
import 'package:chatbot_ui/src/tools.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel message;

  const MessageBubble({required this.message, super.key});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late bool fromBot = widget.message.fromBot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: fromBot? 10: 80,
        right: fromBot? 80: 10,
        bottom: 10
      ),
      child: Align(
        alignment: fromBot
          ? Alignment.centerLeft
          : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fromBot
              ? Theme.of(context).colorScheme.surfaceVariant
              : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
              topLeft: fromBot? const Radius.circular(0) : const Radius.circular(15),
              topRight: fromBot? const Radius.circular(15) : const Radius.circular(0)
            )
          ),
          child: Column(
            crossAxisAlignment: isRtl(widget.message.text)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
            children: [
              if (widget.message.media.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: MediaBubble(media: widget.message.media),
                ),

              Text(
                widget.message.text,
                textDirection: isRtl(widget.message.text)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
                textAlign: isRtl(widget.message.text)
                  ? TextAlign.right
                  : TextAlign.left,
                style: TextStyle(
                  color: fromBot
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
