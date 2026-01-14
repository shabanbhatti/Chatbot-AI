import 'dart:io';

import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';

abstract class ChatRepository {
  Future<ChatEntity> sendPrompt(ChatEntity chatEntity);
  Future<List<ChatEntity>> getChat(int id);
  Future<bool> insertChat(ChatEntity chatEntity);
  Future<String> voiceToText(File filePath);
  Future<bool> updateChat(ChatEntity chatEntity);
  Future<List<ChatRoomEntity>> getChatRooms();
  Future<bool> createChatRoom(ChatRoomEntity chatRoomEntity);
  Future<bool> updateChatRoom(ChatRoomEntity chatRoomEntity);
  Future<bool> deleteChatRoom(int id);
}
