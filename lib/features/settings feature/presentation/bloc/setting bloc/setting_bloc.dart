import 'dart:async';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/domain/usecases/update_user_usecase.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_event.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetUserUsecase getUserUsecase;
  final UpdateUserUsecase updateChatUsecase;

  SettingBloc({required this.getUserUsecase, required this.updateChatUsecase})
    : super(InitialSettingState()) {
    on<GetUserInSettingEvent>(onGetUserEvent);
    on<UpdateUserInSettingEvent>(onUpdateUserEvent);
  }

  Future<void> onGetUserEvent(
    GetUserInSettingEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      emit(LoadingSettingState());
      var user = await getUserUsecase();
      emit(LoadedUserInSettingState(userEntity: user));
    } on Failures catch (e) {
      emit(ErrorSettingState(message: e.message));
    }
  }

  Future<void> onUpdateUserEvent(
    UpdateUserInSettingEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      emit(LoadingSettingState());
      var isUpdated = await updateChatUsecase(event.userEntity);
      if (isUpdated) {
        ShowToast.basicToast(message: 'Updated');
      } else {
        ShowToast.basicToast(
          message: 'Updated Failed',
          color: CupertinoColors.destructiveRed,
        );
      }
      add(GetUserInSettingEvent());
    } on Failures catch (e) {
      emit(ErrorSettingState(message: e.message));
    }
  }
}
