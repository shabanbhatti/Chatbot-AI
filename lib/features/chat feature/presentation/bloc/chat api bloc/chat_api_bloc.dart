import 'dart:async';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatApiBloc extends Bloc<ChatApiEvent, ChatApiState> {
  final SendPromptUsecase sendPromptUsecase;
  ChatApiBloc({required this.sendPromptUsecase}) : super(InitialChatApi()) {
    on<OnSendPromptEvent>(onSendPromptEvent);
    on<OnStopChatApiEvent>(onStopEvent);
    on<OnCloseErrorApiEvent>(onCloseErrorEvent);
  }

  Future<void> onSendPromptEvent(
    OnSendPromptEvent event,
    Emitter<ChatApiState> emit,
  ) async {
    try {
      emit(LoadingChatApi());
      await Future.delayed(const Duration(seconds: 2));
      if (state is! StopChatAPi) {
        // ChatEntity data = ChatEntity(
        //   chatRoomId: event.chatEntity.chatRoomId,
        //   id: DateTime.now().microsecondsSinceEpoch,
        //   message:
        //       'Sorry! Currently, work is in progress on the app, so this service is temporarily disabled 😊',
        //   createdAt: DateTime.now().toString(),
        //   role: ChatRoleConstants.model,
        //   isFav: false,
        //   imgPaths: [],
        // );
        var data = await sendPromptUsecase(event.chatEntity);
        // log('CHAT API BLOC: ${data.id} ');
        // throw ApiFailure(
        //   message: "You've reached today's limit. Please try again tomorrow.",
        // );
        // throw ApiFailure(message: "");
        emit(LoadedChatApi(chatEntity: data));
      }
    } on Failures catch (e) {
      emit(ErrorChatApi(message: e.message));
    }
  }

  Future<void> onStopEvent(
    OnStopChatApiEvent event,
    Emitter<ChatApiState> emit,
  ) async {
    emit(LoadedChatApi(chatEntity: null));
    emit(StopChatAPi());
  }

  Future<void> onCloseErrorEvent(
    OnCloseErrorApiEvent event,
    Emitter<ChatApiState> emit,
  ) async {
    emit(LoadedChatApi(chatEntity: null));
  }
}
