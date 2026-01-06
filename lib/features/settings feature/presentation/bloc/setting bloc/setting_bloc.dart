import 'dart:async';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_chat_bckgnd_img_paths_usecae.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/update_user_usecase.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/delete_chat_img_paths_usecase.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/get_chat_imgs_paths_usecase.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/update_chat_img_path_usecase.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_event.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetUserUsecase getUserUsecase;
  final UpdateUserUsecase updateChatUsecase;
  final GetChatImgsPathsUsecase getChatImgsPathsUsecase;
  final InsertChatBckgndImgPathsUsecae insertChatImgPathUsecase;
  final DeleteChatImgPathsUsecase deleteChatImgPathsUsecase;
  final UpdateChatImgPathUsecase updateChatImgPathUsecase;

  SettingBloc({
    required this.getUserUsecase,
    required this.updateChatImgPathUsecase,
    required this.updateChatUsecase,
    required this.getChatImgsPathsUsecase,
    required this.deleteChatImgPathsUsecase,
    required this.insertChatImgPathUsecase,
  }) : super(InitialSettingState()) {
    on<GetChatbackgroundImgsPathsEvent>(onGetChatbackgroundImgsPathsEvent);
    on<GetUserInSettingEvent>(onGetUserEvent);
    on<UpdateUserInSettingEvent>(onUpdateUserEvent);
    on<InsertChatBackgroundImagePathEvent>(
      onInsertChatBackgroundImagePathEvent,
    );
    on<UpdateChatBackgroundImagePathEvent>(
      onUpdateChatBackgroundImagePathEvent,
    );
    on<InactiveAllChatBackgroundThemeEvent>(
      onInactiveAllChatBackgroundThemeEvent,
    );
  }

  Future<void> onGetUserEvent(
    GetUserInSettingEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      if (state is LoadedSettingState) {
        emit((state as LoadedSettingState).copyWith(isUserLoading: true));
      } else {
        emit(LoadedSettingState(isUserLoading: true));
      }
      var user = await getUserUsecase();
      emit(
        (state as LoadedSettingState).copyWith(
          userEntity: user,
          isUserLoading: false,
        ),
      );
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

  Future<void> onGetChatbackgroundImgsPathsEvent(
    GetChatbackgroundImgsPathsEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      if (state is LoadedSettingState) {
        emit((state as LoadedSettingState).copyWith(isChatImgsLoading: true));
      } else {
        emit(LoadedSettingState(isChatImgsLoading: true));
      }
      // await Future.delayed(Duration(seconds: 3));

      final data = await getChatImgsPathsUsecase();

      emit(
        (state as LoadedSettingState).copyWith(
          chatImgPaths: data,
          isChatImgsLoading: false,
        ),
      );
    } on Failures catch (e) {
      emit(ErrorSettingState(message: e.message));
    }
  }

  Future<void> onInsertChatBackgroundImagePathEvent(
    InsertChatBackgroundImagePathEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      var isInserted = await insertChatImgPathUsecase(
        event.chatBckgndImgPathsEntity,
      );
      if (isInserted) {
        ShowToast.basicToast(message: 'Uploaded');
      } else {
        ShowToast.basicToast(
          message: 'Error found',
          color: CupertinoColors.destructiveRed,
        );
      }
      add(GetChatbackgroundImgsPathsEvent());
    } on Failures catch (e) {
      emit(ErrorSettingState(message: e.message));
    }
  }

  Future<void> onUpdateChatBackgroundImagePathEvent(
    UpdateChatBackgroundImagePathEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      if (event.chatBckgndImgPathsEntity != null) {
        for (var element in event.chatBckgndEntityList) {
          await updateChatImgPathUsecase(
            ChatBckgndImgPathsEntity(
              imgPaths: element.imgPaths,
              isActive: false,
              id: element.id,
            ),
          );
        }
        var isUpdated = await updateChatImgPathUsecase(
          event.chatBckgndImgPathsEntity!,
        );
        if (isUpdated) {
          ShowToast.basicToast(message: 'Active');
        } else {
          ShowToast.basicToast(
            message: 'Error found',
            color: CupertinoColors.destructiveRed,
          );
        }
        var loaded = state as LoadedSettingState;
        var list = loaded.chatImgPaths
            ?.map(
              (e) => (e.id == event.chatBckgndImgPathsEntity?.id)
                  ? e.copyWith(
                      isActive: event.chatBckgndImgPathsEntity?.isActive,
                    )
                  : e.copyWith(isActive: false),
            )
            .toList();
        emit(
          loaded.copyWith(chatImgPaths: list),
          // LoadedSettingState(
          //   isChatImgsLoading: loaded.isChatImgsLoading,
          //   isUserLoading: loaded.isUserLoading,
          //   userEntity: loaded.userEntity,
          //   chatImgPaths: list,
          // ),
        );
      } else {
        for (var element in event.chatBckgndEntityList) {
          await updateChatImgPathUsecase(
            ChatBckgndImgPathsEntity(
              imgPaths: element.imgPaths,
              isActive: false,
              id: element.id,
            ),
          );
        }

        var loaded = state as LoadedSettingState;
        var list = loaded.chatImgPaths
            ?.map((e) => e.copyWith(isActive: false))
            .toList();
        emit(
          loaded.copyWith(chatImgPaths: list),
          // LoadedSettingState(
          //   isChatImgsLoading: loaded.isChatImgsLoading,
          //   isUserLoading: loaded.isUserLoading,
          //   userEntity: loaded.userEntity,
          //   chatImgPaths: list,
          // ),
        );
      }
    } on Failures catch (e) {
      emit(ErrorSettingState(message: e.message));
    }
  }

  Future<void> onInactiveAllChatBackgroundThemeEvent(
    InactiveAllChatBackgroundThemeEvent event,
    Emitter<SettingState> emit,
  ) async {
    for (var element in event.chatBckgndEntityList) {
      await updateChatImgPathUsecase(
        ChatBckgndImgPathsEntity(
          imgPaths: element.imgPaths,
          isActive: false,
          id: element.id,
        ),
      );
    }
    // var loaded = state as LoadedSettingState;
    // var list = loaded.chatImgPaths
    //     ?.map((e) => e.copyWith(isActive: false))
    //     .toList();
    // emit(loaded.copyWith(chatImgPaths: list));
  }
}
