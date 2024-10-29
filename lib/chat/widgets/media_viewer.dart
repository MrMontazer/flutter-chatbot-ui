import 'dart:io';
import 'dart:ui';

import 'package:chatbot_ui/chat/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class MediaThumbnail extends StatefulWidget {
  final MediaModel file;
  final void Function(MediaModel file)? onAttachmentTap;
  const MediaThumbnail({required this.file, this.onAttachmentTap, super.key});

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  @override
  Widget build(BuildContext context) {
    if (widget.file.inProgress || widget.file.media == null) return inGenerateMedia();

    Widget child;
    var file = widget.file.media!;

    if (file.extension == 'jpg' || file.extension == 'png' || file.extension == 'jpeg' || file.extension == 'gif'){
      child = Container(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(file.path!),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      );
    } else {
      child = Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          file.extension ?? file.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
      );
    }

    return GestureDetector(
      child: child,
      onTap: () => widget.onAttachmentTap?.call(widget.file),
    );
  }

  Widget inGenerateMedia(){
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark
          ? theme.colorScheme.surfaceVariant.withOpacity(0.2)
          : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: (widget.file.media == null)
            ? Image.file(
                File(widget.file.media!.path!),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              )
            : null,
        ),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(delay: 250.ms, duration: 1.seconds);
  }
}

class MediaBubble extends StatefulWidget {
  const MediaBubble({required this.media, super.key});

  final List<MediaModel> media;

  @override
  State<MediaBubble> createState() => _MediaBubbleState();
}

class _MediaBubbleState extends State<MediaBubble> {
  @override
  Widget build(BuildContext context) {
    var media = widget.media;
    var count = media.length;

    if (count == 1){
      return AspectRatio(
        aspectRatio: 1,
        child: MediaThumbnail(file: media[0])
      );
    }
    else if (count == 2){
      return AspectRatio(
        aspectRatio: 1,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(child: MediaThumbnail(file: media[0])),
            const SizedBox(width: 5),
            Expanded(child: MediaThumbnail(file: media[1]))
          ],
        ),
      );
    }
    else if (count == 3) {
      return AspectRatio(
        aspectRatio: 1,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(child: MediaThumbnail(file: media[0])),
            const SizedBox(height: 5),
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(child: MediaThumbnail(file: media[1])),
                  const SizedBox(width: 5),
                  Expanded(child: MediaThumbnail(file: media[2]))
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: [
          if (count == 4)
            for (var file in widget.media)
              MediaThumbnail(file: file)
          else
            for (var file in widget.media.sublist(0, 3))
              MediaThumbnail(file: file),

          if (count > 4)
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(150),
                  width: 2
                )
              ),
              child: Text(
                "+${count-3}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(150),
                  fontSize: 25,
                ),
              ),
            )
        ],
      ),
    );
  }
}
