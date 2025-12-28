import 'dart:io';

import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class VoiceToTextUsecase {
  final ChatRepository chatRepository;
  const VoiceToTextUsecase({required this.chatRepository});

  Future<String> call(File filePath) async {
    return chatRepository.voiceToText(filePath);
  }
}
