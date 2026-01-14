import 'package:equatable/equatable.dart';

sealed class ChatRoomIdPrefEvent extends Equatable {
  const ChatRoomIdPrefEvent();
  @override
  List<Object?> get props => [];
}

class SetChatRoomIdPrefEvent extends ChatRoomIdPrefEvent {
  final int value;
  const SetChatRoomIdPrefEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class GetChatRoomIdPrefEvent extends ChatRoomIdPrefEvent {
  const GetChatRoomIdPrefEvent();
}
