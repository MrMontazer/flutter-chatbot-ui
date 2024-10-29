part of 'chat_bloc.dart';

sealed class ChatState {
  const ChatState();
}

final class ChatInitial extends ChatState {}

final class ChatLoadInProgress extends ChatState {}

final class ChatTypingInProgress extends ChatState {}

enum MessageUpdateEvent {
  newMessageFromUser,
  updateMessage,
}

final class ChatMessagesUpdated extends ChatState {
  const ChatMessagesUpdated(this.event);

  final MessageUpdateEvent event;
}
