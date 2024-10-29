part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class ChatHistoryLoaded extends ChatEvent {}

final class ChatMessageSent extends ChatEvent {
  final MessageModel message;
  const ChatMessageSent(this.message);

  @override
  List<Object> get props => [message];
}
