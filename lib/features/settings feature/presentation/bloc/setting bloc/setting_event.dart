import 'package:chatbot_ai/core/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object?> get props => [];
}

class GetUserInSettingEvent extends SettingEvent {
  const GetUserInSettingEvent();
}

class UpdateUserInSettingEvent extends SettingEvent {
  final UserEntity userEntity;
  const UpdateUserInSettingEvent({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}
