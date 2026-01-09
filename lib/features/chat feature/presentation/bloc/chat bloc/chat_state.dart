import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class InitialChat extends ChatState {
  const InitialChat();
}

class LoadingChat extends ChatState {
  const LoadingChat();
}

class LoadingOnSendingChat extends ChatState {
  const LoadingOnSendingChat();
}

class LoadedChat extends ChatState {
  final List<ChatEntity> chatsList;
  final UserEntity userEntity;
  final ChatBckgndImgPathsEntity? chatBckgndImgPathsEntity;
  const LoadedChat({
    required this.chatsList,
    required this.userEntity,
    required this.chatBckgndImgPathsEntity,
  });
  @override
  List<Object?> get props => [chatsList, userEntity, chatBckgndImgPathsEntity];
}

class LoadedInsertedChat extends ChatState {
  const LoadedInsertedChat();
}

class ErrorChat extends ChatState {
  final String message;
  const ErrorChat({required this.message});
  @override
  List<Object?> get props => [message];
}
