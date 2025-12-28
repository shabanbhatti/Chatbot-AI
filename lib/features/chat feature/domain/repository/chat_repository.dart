import 'dart:io';

import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';

abstract class ChatRepository {
  Future<ChatEntity> sendPrompt(ChatEntity chatEntity);
  Future<List<ChatEntity>> getChat();
  Future<bool> insertChat(ChatEntity chatEntity);
  Future<String> voiceToText(File filePath);
}
