import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class InsertEvent extends ChatEvent {
  final ChatEntity chatEntity;
  const InsertEvent({required this.chatEntity});
}

class GetChatsEvent extends ChatEvent {
  const GetChatsEvent();
}

class SendPromptEvent extends ChatEvent {
  final ChatEntity chatEntity;
  const SendPromptEvent({required this.chatEntity});
  @override
  List<Object?> get props => [chatEntity];
}
