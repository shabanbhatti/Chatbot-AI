import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatApiState extends Equatable {
  const ChatApiState();
  @override
  List<Object?> get props => [];
}

class InitialChatApi extends ChatApiState {
  const InitialChatApi();
}

class LoadingChatApi extends ChatApiState {
  const LoadingChatApi();
}

class StopChatAPi extends ChatApiState {
  const StopChatAPi();
}

class LoadedChatApi extends ChatApiState {
  final ChatEntity? chatEntity;
  const LoadedChatApi({required this.chatEntity});
  @override
  List<Object?> get props => [chatEntity];
}

class ErrorChatApi extends ChatApiState {
  final String message;
  const ErrorChatApi({required this.message});
  @override
  List<Object?> get props => [message];
}
