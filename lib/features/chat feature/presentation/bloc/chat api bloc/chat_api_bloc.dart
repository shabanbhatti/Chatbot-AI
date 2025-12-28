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
  }

  Future<void> onSendPromptEvent(
    OnSendPromptEvent event,
    Emitter<ChatApiState> emit,
  ) async {
    try {
      emit(LoadingChatApi());
      var data = await sendPromptUsecase(event.chatEntity);

      emit(LoadedChatApi(chatEntity: data));
    } on Failures catch (e) {
      emit(ErrorChatApi(message: e.message));
    }
  }
}
