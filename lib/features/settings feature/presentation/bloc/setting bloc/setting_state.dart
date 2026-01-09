import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SettingState extends Equatable {
  const SettingState();
  @override
  List<Object?> get props => [];
}

class InitialSettingState extends SettingState {
  const InitialSettingState();
}

class LoadingSettingState extends SettingState {
  const LoadingSettingState();
}

class LoadedSettingState extends SettingState {
  final UserEntity? userEntity;
  final List<ChatBckgndImgPathsEntity>? chatImgPaths;

  const LoadedSettingState({this.userEntity, this.chatImgPaths});

  LoadedSettingState copyWith({
    UserEntity? userEntity,
    List<ChatBckgndImgPathsEntity>? chatImgPaths,
  }) {
    return LoadedSettingState(
      userEntity: userEntity ?? this.userEntity,
      chatImgPaths: chatImgPaths ?? this.chatImgPaths,
    );
  }

  @override
  List<Object?> get props => [userEntity, chatImgPaths];
}

class ErrorSettingState extends SettingState {
  final String message;
  const ErrorSettingState({required this.message});
  @override
  List<Object?> get props => [message];
}
