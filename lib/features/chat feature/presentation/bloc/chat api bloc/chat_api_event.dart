import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatApiEvent extends Equatable {
  const ChatApiEvent();
  @override
  List<Object?> get props => [];
}

class OnSendPromptEvent extends ChatApiEvent {
  final ChatEntity chatEntity;
  const OnSendPromptEvent({required this.chatEntity});
  @override
  List<Object?> get props => [chatEntity];
}

class OnStopChatApiEvent extends ChatApiEvent {
  const OnStopChatApiEvent();
}
