import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();
  @override
  List<Object?> get props => [];
}

class CreateChatRoomEvent extends ChatRoomEvent {
  final ChatRoomEntity chatRoomEntity;
  const CreateChatRoomEvent({required this.chatRoomEntity});
  @override
  List<Object?> get props => [chatRoomEntity];
}

class UpdateChatRoomEvent extends ChatRoomEvent {
  final ChatRoomEntity chatRoomEntity;
  const UpdateChatRoomEvent({required this.chatRoomEntity});
  @override
  List<Object?> get props => [chatRoomEntity];
}

class CreateFirstChatRoomEvent extends ChatRoomEvent {
  final ChatRoomEntity chatRoomEntity;
  const CreateFirstChatRoomEvent({required this.chatRoomEntity});
  @override
  List<Object?> get props => [chatRoomEntity];
}

class GetChatRoomsEvent extends ChatRoomEvent {
  const GetChatRoomsEvent();
}

class DeleteChatRoomEvent extends ChatRoomEvent {
  final int id;
  const DeleteChatRoomEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class SearchOnChangedEvent extends ChatRoomEvent {
  final String query;
  const SearchOnChangedEvent({required this.query});
  @override
  List<Object?> get props => [query];
}

class PinOrUnpinChatRoomEvent extends ChatRoomEvent {
  final ChatRoomEntity chatRoomEntity;
  const PinOrUnpinChatRoomEvent({required this.chatRoomEntity});
  @override
  List<Object?> get props => [chatRoomEntity];
}
