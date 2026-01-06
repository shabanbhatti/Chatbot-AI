import 'dart:async';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_state.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/get_chat_imgs_paths_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendPromptUsecase sendPromptUsecase;
  final GetChatsUsecase getChatsUsecase;
  final InsertChatUsecase insertChatUsecase;
  final UpdateChatUsecase updateChatUsecase;
  final GetUserUsecase getUserUsecase;
  final GetChatImgsPathsUsecase getChatImgsPathsUsecase;
  ChatBloc({
    required this.sendPromptUsecase,
    required this.getUserUsecase,
    required this.getChatImgsPathsUsecase,
    required this.insertChatUsecase,
    required this.updateChatUsecase,
    required this.getChatsUsecase,
  }) : super(InitialChat()) {
    // on<SendPromptEvent>(onSendPromptEvent);
    on<InsertEvent>(onInsertPromptEvent);
    on<GetChatsEvent>(onGetChatsEvent);
    on<UpdateChatEvent>(onUpdateChatEvent);
    // on<GetUserInDrawerEvent>(onGetUserInDrawerEvent);
  }

  Future<void> onGetChatsEvent(
    GetChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(LoadingChat());

      await Future.delayed(Duration(seconds: 2));
      var data = await getChatsUsecase();
      var user = await getUserUsecase();
      var backgroundImg = await getChatImgsPathsUsecase();
      List<ChatBckgndImgPathsEntity> paths = backgroundImg
          .where((e) => e.isActive)
          .toList();

      ChatBckgndImgPathsEntity? finalPath = (paths.isEmpty) ? null : paths[0];
      emit(
        LoadedChat(
          chatsList: data,
          userEntity: user,
          chatBckgndImgPathsEntity: finalPath,
        ),
      );
    } on Failures catch (e) {
      emit(ErrorChat(message: e.message));
    }
  }

  Future<void> onInsertPromptEvent(
    InsertEvent event,
    Emitter<ChatState> emit,
  ) async {
    // emit(LoadingChat());

    await insertChatUsecase(event.chatEntity);
    var loaded = state as LoadedChat;
    List<ChatEntity> list = [...loaded.chatsList];
    list.add(event.chatEntity);
    emit(
      LoadedChat(
        chatsList: list,
        userEntity: loaded.userEntity,
        chatBckgndImgPathsEntity: loaded.chatBckgndImgPathsEntity,
      ),
    );
  }

  Future<void> onUpdateChatEvent(
    UpdateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      var isInserted = await updateChatUsecase(event.chatEntity);
      var loaded = state as LoadedChat;

      var data = loaded.chatsList
          .map(
            (e) => (e.id == event.chatEntity.id)
                ? e.copyWith(isFav: event.chatEntity.isFav)
                : e,
          )
          .toList();

      emit(
        LoadedChat(
          chatsList: data,
          userEntity: loaded.userEntity,
          chatBckgndImgPathsEntity: loaded.chatBckgndImgPathsEntity,
        ),
      );
    } on Failures catch (e) {
      emit(ErrorChat(message: e.message));
    }
  }
}
