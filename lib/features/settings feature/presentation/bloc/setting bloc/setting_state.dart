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

  final bool isUserLoading;
  final bool isChatImgsLoading;

  const LoadedSettingState({
    this.userEntity,
    this.chatImgPaths,
    this.isUserLoading = false,
    this.isChatImgsLoading = false,
  });

  LoadedSettingState copyWith({
    UserEntity? userEntity,
    List<ChatBckgndImgPathsEntity>? chatImgPaths,
    bool? isUserLoading,
    bool? isChatImgsLoading,
  }) {
    return LoadedSettingState(
      userEntity: userEntity ?? this.userEntity,
      chatImgPaths: chatImgPaths ?? this.chatImgPaths,
      isUserLoading: isUserLoading ?? this.isUserLoading,
      isChatImgsLoading: isChatImgsLoading ?? this.isChatImgsLoading,
    );
  }

  @override
  List<Object?> get props => [
    isUserLoading,
    isChatImgsLoading,
    userEntity,
    chatImgPaths,
  ];
}

class ErrorSettingState extends SettingState {
  final String message;
  const ErrorSettingState({required this.message});
  @override
  List<Object?> get props => [message];
}
