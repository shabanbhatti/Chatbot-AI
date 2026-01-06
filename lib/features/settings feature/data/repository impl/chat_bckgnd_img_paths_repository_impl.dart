import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/features/settings%20feature/data/datasource/local%20datasource/chat_bckgnd_img_paths_local_datasource.dart';
import 'package:chatbot_ai/features/settings%20feature/data/models/chat_bckgnd_img_paths_model.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/repository/chat_bckgnd_img_paths_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class ChatBckgndImgPathsRepositoryImpl implements ChatBckgndImgPathsRepository {
  final ChatBckgndImgPathsLocalDatasource chatBckgndImgPathsLocalDatasource;
  const ChatBckgndImgPathsRepositoryImpl({
    required this.chatBckgndImgPathsLocalDatasource,
  });
  @override
  Future<bool> deleteImages(int id) async {
    try {
      return await chatBckgndImgPathsLocalDatasource.deleteImages(id);
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<List<ChatBckgndImgPathsEntity>> getImages() async {
    try {
      var data = await chatBckgndImgPathsLocalDatasource.getImages();
      return data.map((e) => e.toEntity()).toList();
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> insertImages(
    ChatBckgndImgPathsEntity chatBckgndImgPathEntity,
  ) async {
    try {
      return await chatBckgndImgPathsLocalDatasource.insertImages(
        ChatBckgndImgPathsModel(
          imgPaths: chatBckgndImgPathEntity.imgPaths,
          isActive: chatBckgndImgPathEntity.isActive,
          id: chatBckgndImgPathEntity.id,
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> updateImages(
    ChatBckgndImgPathsEntity chatBckgndImgPathEntity,
  ) async {
    try {
      return await chatBckgndImgPathsLocalDatasource.updateImages(
        ChatBckgndImgPathsModel(
          imgPaths: chatBckgndImgPathEntity.imgPaths,
          isActive: chatBckgndImgPathEntity.isActive,
          id: chatBckgndImgPathEntity.id,
        ),
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
