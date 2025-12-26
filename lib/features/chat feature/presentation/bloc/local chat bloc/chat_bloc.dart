import 'dart:async';

import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/local_chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/local_chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendPromptUsecase sendPromptUsecase;
  final GetChatsUsecase getChatsUsecase;
  final InsertChatUsecase insertChatUsecase;
  ChatBloc({
    required this.sendPromptUsecase,
    required this.insertChatUsecase,
    required this.getChatsUsecase,
  }) : super(InitialChat()) {
    on<SendPromptEvent>(onSendPromptEvent);
    on<InsertEvent>(onInsertPromptEvent);
    on<GetChatsEvent>(onGetChatsEvent);
  }

  FutureOr<void> onSendPromptEvent(
    SendPromptEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(LoadingOnSendingChat());
      // var data = await sendPromptUsecase(event.chatEntity);
      await Future.delayed(const Duration(seconds: 4));
      var data = ChatEntity(
        message: 'Hi bro i am good man',
        createdAt: DateTime.now().toString(),
        role: ChatRoleConstants.model,
        imgPath: '',
      );
      await insertChatUsecase(data);
      add(GetChatsEvent());
    } on Failures catch (e) {
      emit(ErrorChat(message: e.message));
    }
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
  }
}
