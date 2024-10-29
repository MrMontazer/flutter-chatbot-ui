import 'dart:io';

import 'package:chatbot_ui/chat/bloc/chat_bloc.dart';
import 'package:chatbot_ui/chat/models/message_model.dart';
import 'package:chatbot_ui/chat/widgets/media_viewer.dart';
import 'package:chatbot_ui/src/tools.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({super.key});

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  var controller = TextEditingController();
  List<PlatformFile> attachments = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attachments.isNotEmpty)
            AttachmentBox(
              attachments: attachments,
              onAttachmentTap: (file) => setState(() => attachments.remove(file)),
            ),
            
          Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: AnimatedSize(
                    duration: 200.ms,
                    curve: Curves.easeOut,
                    child: TextField(
                      controller: controller,
                      contentInsertionConfiguration: ContentInsertionConfiguration(
                        onContentInserted: (KeyboardInsertedContent data) async {
                          if (data.data == null) return;
                          var filename = data.uri.split('/').last;
                          var tempdir = await getTemporaryDirectory();

                          await File('${tempdir.path}/$filename').writeAsBytes(data.data!);
                                    
                          setState(() {
                            attachments.add(
                              PlatformFile(
                                path: '${tempdir.path}/$filename',
                                name: filename,
                                size: data.data!.length
                              )
                            );
                          });
                        },
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (value) => setState((){}),
                      textAlign: isRtl(controller.text)
                          ? TextAlign.right
                          : TextAlign.left,
                      textDirection: isRtl(controller.text)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      decoration: InputDecoration(
                          hintText: "Message",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          suffixIcon: controller.text.trim().isNotEmpty
                            ? IconButton(
                                onPressed: sendMessage,
                                icon: const Icon(Icons.send_rounded),
                              )
                            : null
                          ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  var result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: [
                      'jpg',
                      'png',
                      'gif',
                      'pdf',
                      'doc',
                      'docx',
                      'txt'
                    ],
                  );

                  if (result != null) setState(() => attachments.addAll(result.files));
                },
                icon: const Icon(
                  Icons.add_rounded,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    if (controller.text.isEmpty) return;

    List<MediaModel> media = [];
    for (var file in attachments) {
      media.add(MediaModel(media: file));
    }

    var message = MessageModel(
      fromBot: false,
      text: controller.text.trim(),
      media: attachments.map((file) => MediaModel(media: file)).toList()
    );

    context.read<ChatBloc>().add(ChatMessageSent(message));
    setState((){
      controller.clear();
      attachments.clear();
    });
  }
}

class AttachmentBox extends StatelessWidget {
  const AttachmentBox({required this.attachments, required this.onAttachmentTap, super.key});

  final List<PlatformFile> attachments;
  final void Function(PlatformFile file) onAttachmentTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var file in attachments)
              filePreview(
                context: context,
                file: file,
              ),
          ],
        ),
      ),
    );
  }

  Widget filePreview({required BuildContext context, required PlatformFile file}) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      width: 70,
      height: 70,
      child: MediaThumbnail(
        file: MediaModel(media: file),
        onAttachmentTap: (media) => onAttachmentTap(media.media!),
      ),
    );
  }
}
