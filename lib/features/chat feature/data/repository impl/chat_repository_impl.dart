import 'dart:io';

import 'package:chatbot_ai/core/errors/exceptions/dio_exception_handeller.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/chat%20feature/data/datasource/local%20datasource/chat_local_datasource.dart';
import 'package:chatbot_ai/features/chat%20feature/data/datasource/remote%20datasource/chat_remote_datasource.dart';
import 'package:chatbot_ai/features/chat%20feature/data/models/chat_model.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqlite_api.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;
  final ChatLocalDatasource chatLocalDatasource;
  const ChatRepositoryImpl({
    required this.chatRemoteDatasource,
    required this.chatLocalDatasource,
  });

  @override
  Future<ChatEntity> sendPrompt(ChatEntity chatEnity) async {
    try {
      var data = await chatRemoteDatasource.sendPrompt(
        ChatModel(
          message: chatEnity.message,
          createdAt: chatEnity.createdAt,
          role: chatEnity.role,
          imgPath: chatEnity.imgPath,
        ),
      );
      return data.toEntity();
    } on DioException catch (e) {
      var message = DioExceptionHandeler.getMessage(e);
      throw ApiFailure(message: message);
    }
  }

  @override
  Future<List<ChatEntity>> getChat() async {
    try {
      var data = await chatLocalDatasource.getChat();
      return data.map((e) => e.toEntity()).toList();
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> insertChat(ChatEntity chatEntity) async {
    try {
      return await chatLocalDatasource.insertChat(
        ChatModel(
          message: chatEntity.message,
          createdAt: chatEntity.createdAt,
          role: chatEntity.role,
          imgPath: chatEntity.imgPath ?? '',
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<String> voiceToText(File filePath) async {
    try {
      return await chatRemoteDatasource.voiceToText(filePath);
    } on DioException catch (e) {
      var message = DioExceptionHandeler.getMessage(e);
      throw ApiFailure(message: message);
    }
  }
}
