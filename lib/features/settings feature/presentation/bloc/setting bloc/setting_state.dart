import 'package:chatbot_ai/core/domain/entity/user_entity.dart';
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

class LoadedUserInSettingState extends SettingState {
  final UserEntity userEntity;
  const LoadedUserInSettingState({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}

class ErrorSettingState extends SettingState {
  final String message;
  const ErrorSettingState({required this.message});
  @override
  List<Object?> get props => [message];
}
