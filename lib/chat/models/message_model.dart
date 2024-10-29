import 'package:file_picker/file_picker.dart';

class MessageModel {
  MessageModel({
    required this.fromBot,
    required this.text,
    List<MediaModel>? media
  }): media = media ?? [];

  final bool fromBot;
  String text;
  List<MediaModel> media;
}

class MediaModel {
  MediaModel({
    this.media,
    this.inProgress = false,
  });

  bool inProgress;
  PlatformFile? media;

  MediaModel copyWith({bool? inProgress, PlatformFile? media}) =>
    MediaModel(
      inProgress: inProgress ?? this.inProgress,
      media: media ?? this.media,
    );
}
