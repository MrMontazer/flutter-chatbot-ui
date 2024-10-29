import 'package:bloc/bloc.dart';
import 'package:chatbot_ui/chat/models/message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_animate/flutter_animate.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<MessageModel> messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<ChatHistoryLoaded>(_onLoadChatHistory);
    on<ChatMessageSent>(_onMessageSent);
  }

  Future<void> _onLoadChatHistory(ChatHistoryLoaded event, Emitter<ChatState> emit) async {
    emit(ChatLoadInProgress());
    await Future.delayed(1.seconds);
    emit(const ChatMessagesUpdated(MessageUpdateEvent.updateMessage));
  }

  Future<void> _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    MessageModel message = MessageModel(fromBot: true, text: "Thinking...");

    messages.add(event.message);
    messages.add(message);
    emit(const ChatMessagesUpdated(MessageUpdateEvent.newMessageFromUser));
    await Future.delayed(1.seconds);

    message.text = "";
    for (var media in event.message.media) {
      media = media.copyWith();
      message.media.insert(0, media);

      media.inProgress = true;
      emit(ChatTypingInProgress());
      await Future.delayed(2.seconds);

      media.inProgress = false;
      emit(ChatTypingInProgress());
    }

    for (var char in event.message.text.runes) {
      message.text += String.fromCharCode(char);
      emit(ChatTypingInProgress());
      await Future.delayed(5.ms);
    }

    emit(const ChatMessagesUpdated(MessageUpdateEvent.updateMessage));
  }
}
