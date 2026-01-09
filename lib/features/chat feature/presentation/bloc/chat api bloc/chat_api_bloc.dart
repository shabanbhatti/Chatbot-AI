import 'dart:async';

import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
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
      await Future.delayed(const Duration(seconds: 2));
      ChatEntity data = ChatEntity(
        message:
            'Sorry! Currently, work is in progress on the app, so this service is temporarily disabled 😊',
        createdAt: DateTime.now().toString(),
        role: ChatRoleConstants.model,
        isFav: false,
        imgPath: '',
      );

      emit(LoadedChatApi(chatEntity: data));
    } on Failures catch (e) {
      emit(ErrorChatApi(message: e.message));
    }
  }
}
