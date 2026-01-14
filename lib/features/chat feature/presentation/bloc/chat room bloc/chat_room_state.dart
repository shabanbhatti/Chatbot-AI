import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatRoomState extends Equatable {
  const ChatRoomState();
  @override
  List<Object?> get props => [];
}

class InitialChatRoom extends ChatRoomState {
  const InitialChatRoom();
}

class LoadingChatRoom extends ChatRoomState {
  const LoadingChatRoom();
}

class LoadedChatRoom extends ChatRoomState {
  final List<ChatRoomEntity> chatRoomEntities;
  const LoadedChatRoom({required this.chatRoomEntities});
  @override
  List<Object?> get props => [chatRoomEntities];
}

class CreatedFirstTimeChatRoom extends ChatRoomState {
  final int id;
  const CreatedFirstTimeChatRoom({required this.id});
  @override
  List<Object?> get props => [id];
}

class CreatedChatRoom extends ChatRoomState {
  final int id;
  const CreatedChatRoom({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeletedChatRoom extends ChatRoomState {
  const DeletedChatRoom();
}

class ErrorChatRoom extends ChatRoomState {
  final String message;
  const ErrorChatRoom({required this.message});
  @override
  List<Object?> get props => [message];
}
