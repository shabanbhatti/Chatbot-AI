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
          chatRoomId: chatEnity.chatRoomId,
          message: chatEnity.message,
          createdAt: chatEnity.createdAt,
          role: chatEnity.role,
          imgPaths: chatEnity.imgPaths,
          isFav: chatEnity.isFav,
          id: chatEnity.id,
        ),
      );
      return data.toEntity();
    } on DioException catch (e) {
      var message = DioExceptionHandeler.getMessage(e);
      throw ApiFailure(message: message);
    }
  }

  @override
  Future<List<ChatEntity>> getChat(int id) async {
    try {
      var data = await chatLocalDatasource.getChat(id);
      var chatEntityList = data.map((e) => e.toEntity()).toList();
      List<ChatEntity> list = [];

      for (var chat in chatEntityList) {
        var imgPaths = await chatLocalDatasource.getImgsPath(chat.id ?? 0);
        List<String> chatImgs = imgPaths.map((e) => e.imgPath).toList();
        list.add(chat.copyWith(imgPaths: chatImgs));
      }

      return list;
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> insertChat(ChatEntity chatEntity) async {
    try {
      for (var element in chatEntity.imgPaths) {
        await chatLocalDatasource.insertImages(
          ImagePathsModel(
            id: DateTime.now().microsecondsSinceEpoch,
            imgPath: element,
            wholeImgId: chatEntity.id ?? 0,
          ),
        );
      }
      return await chatLocalDatasource.insertChat(
        ChatModel(
          chatRoomId: chatEntity.chatRoomId,
          message: chatEntity.message,
          createdAt: chatEntity.createdAt,
          role: chatEntity.role,
          imgPaths: [],
          isFav: chatEntity.isFav,
          id: chatEntity.id,
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

  @override
  Future<bool> updateChat(ChatEntity chatEntity) async {
    try {
      // log('Id: ${chatEntity.id}');
      // log('fav: ${chatEntity.isFav}');
      return await chatLocalDatasource.updateChat(
        ChatModel(
          chatRoomId: chatEntity.chatRoomId,
          isFav: chatEntity.isFav,
          message: chatEntity.message,
          createdAt: chatEntity.createdAt,
          role: chatEntity.role,
          id: chatEntity.id,
          imgPaths: [],
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> createChatRoom(ChatRoomEntity chatRoomEntity) async {
    try {
      return await chatLocalDatasource.createChatRoom(
        ChatRoomModel(
          isTitleAssigned: chatRoomEntity.isTitleAssigned,
          id: chatRoomEntity.id,
          createdAt: chatRoomEntity.createdAt,
          title: chatRoomEntity.title,
          isPin: chatRoomEntity.isPin,
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<ChatRoomEntity>> getChatRooms() async {
    try {
      var data = await chatLocalDatasource.getChatRooms();
      return data.map((e) => e.toEntity()).toList();
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> deleteChatRoom(int id) async {
    try {
      return await chatLocalDatasource.deleteChatRoom(id);
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> updateChatRoom(ChatRoomEntity chatRoomEntity) async {
    try {
      return await chatLocalDatasource.updateChatRoom(
        ChatRoomModel(
          isTitleAssigned: chatRoomEntity.isTitleAssigned,
          id: chatRoomEntity.id,
          createdAt: chatRoomEntity.createdAt,
          title: chatRoomEntity.title,
          isPin: chatRoomEntity.isPin,
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<ImagePathsEntity>> getImgsPath(int id) async {
    try {
      var data = await chatLocalDatasource.getImgsPath(id);
      return data.map((e) => e.toEntity()).toList();
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> insertImages(ImagePathsEntity imagePathsEntity) async {
    try {
      return await chatLocalDatasource.insertImages(
        ImagePathsModel(
          id: imagePathsEntity.id,
          imgPath: imagePathsEntity.imgPath,
          wholeImgId: imagePathsEntity.wholeImgId,
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
