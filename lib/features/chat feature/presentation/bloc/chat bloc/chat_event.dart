import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class GetUserInDrawerEvent extends ChatEvent {
  const GetUserInDrawerEvent();
}

class InsertEvent extends ChatEvent {
  final ChatEntity chatEntity;
  const InsertEvent({required this.chatEntity});
  @override
  List<Object?> get props => [chatEntity];
}

class GetChatsEvent extends ChatEvent {
  const GetChatsEvent();
}

class UpdateChatEvent extends ChatEvent {
  final ChatEntity chatEntity;
  const UpdateChatEvent({required this.chatEntity});
  @override
  List<Object?> get props => [chatEntity];
}
