import 'dart:async';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendPromptUsecase sendPromptUsecase;
  final GetChatsUsecase getChatsUsecase;
  final InsertChatUsecase insertChatUsecase;
  final UpdateChatUsecase updateChatUsecase;
  ChatBloc({
    required this.sendPromptUsecase,
    required this.insertChatUsecase,
    required this.updateChatUsecase,
    required this.getChatsUsecase,
  }) : super(InitialChat()) {
    // on<SendPromptEvent>(onSendPromptEvent);
    on<InsertEvent>(onInsertPromptEvent);
    on<GetChatsEvent>(onGetChatsEvent);
    on<UpdateChatEvent>(onUpdateChatEvent);
  }

  Future<void> onGetChatsEvent(
    GetChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(LoadingChat());
      var data = await getChatsUsecase();
      emit(LoadedChat(chatsList: data));
    } on Failures catch (e) {
      emit(ErrorChat(message: e.message));
    }
  }

  Future<void> onInsertPromptEvent(
    InsertEvent event,
    Emitter<ChatState> emit,
  ) async {
    await insertChatUsecase(event.chatEntity);
    add(GetChatsEvent());
  }

  Future<void> onUpdateChatEvent(
    UpdateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      var isInserted = await updateChatUsecase(event.chatEntity);
      if (isInserted) {
        emit(LoadedInsertedChat());
      } else {
        // ShowToast.basicToast(message: 'FAILED');
      }
    } on Failures catch (e) {
      emit(ErrorChat(message: e.message));
    }
  }
}
