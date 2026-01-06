import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object?> get props => [];
}

class GetChatbackgroundImgsPathsEvent extends SettingEvent {
  const GetChatbackgroundImgsPathsEvent();
}

class InsertChatBackgroundImagePathEvent extends SettingEvent {
  final ChatBckgndImgPathsEntity chatBckgndImgPathsEntity;
  const InsertChatBackgroundImagePathEvent({
    required this.chatBckgndImgPathsEntity,
  });
  @override
  List<Object?> get props => [chatBckgndImgPathsEntity];
}

class UpdateChatBackgroundImagePathEvent extends SettingEvent {
  final ChatBckgndImgPathsEntity? chatBckgndImgPathsEntity;
  final List<ChatBckgndImgPathsEntity> chatBckgndEntityList;
  const UpdateChatBackgroundImagePathEvent({
    this.chatBckgndImgPathsEntity,
    required this.chatBckgndEntityList,
  });
  @override
  List<Object?> get props => [chatBckgndImgPathsEntity, chatBckgndEntityList];
}

class GetUserInSettingEvent extends SettingEvent {
  const GetUserInSettingEvent();
}

class InactiveAllChatBackgroundThemeEvent extends SettingEvent {
  final List<ChatBckgndImgPathsEntity> chatBckgndEntityList;
  const InactiveAllChatBackgroundThemeEvent({
    required this.chatBckgndEntityList,
  });
  @override
  List<Object?> get props => [chatBckgndEntityList];
}

class UpdateUserInSettingEvent extends SettingEvent {
  final UserEntity userEntity;

  const UpdateUserInSettingEvent({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}
