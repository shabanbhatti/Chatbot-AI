import 'package:chatbot_ai/core/database/app_database.dart';
import 'package:chatbot_ai/features/settings%20feature/data/models/chat_bckgnd_img_paths_model.dart';

abstract class ChatBckgndImgPathsLocalDatasource {
  Future<List<ChatBckgndImgPathsModel>> getImages();
  Future<bool> insertImages(ChatBckgndImgPathsModel chatBckgndImgPathModel);
  Future<bool> deleteImages(int id);
  Future<bool> updateImages(ChatBckgndImgPathsModel chatBckgndImgPathModel);
}

class ChatBckgndImgPathsLocalDatasourceImpl
    implements ChatBckgndImgPathsLocalDatasource {
  final AppDatabase appDatabase;

  const ChatBckgndImgPathsLocalDatasourceImpl({required this.appDatabase});

  @override
  Future<List<ChatBckgndImgPathsModel>> getImages() async {
    var db = await appDatabase.database;
    var data = await db.query(ChatBckgndImgPathsModel.tableName);
    return data.map((e) => ChatBckgndImgPathsModel.fromMap(e)).toList();
  }

  @override
  Future<bool> insertImages(
    ChatBckgndImgPathsModel chatBckgndImgPathModel,
  ) async {
    var db = await appDatabase.database;
    var isInserted = await db.insert(
      ChatBckgndImgPathsModel.tableName,
      chatBckgndImgPathModel.toMap(),
    );
    return isInserted > 0;
  }

  @override
  Future<bool> deleteImages(int id) async {
    var db = await appDatabase.database;
    var isDeleted = await db.delete(
      ChatBckgndImgPathsModel.tableName,
      where: '${ChatBckgndImgPathsModel.idCol}=?',
      whereArgs: [id],
    );
    return isDeleted > 0;
  }
  
  @override
  Future<bool> updateImages(ChatBckgndImgPathsModel chatBckgndImgPathModel)async{
      var db = await appDatabase.database;
    var isUpdated = await db.update(
      ChatBckgndImgPathsModel.tableName,chatBckgndImgPathModel.toMap(),
      where: '${ChatBckgndImgPathsModel.idCol}=?',
      whereArgs: [chatBckgndImgPathModel.id],
    );
    return isUpdated > 0;
  }
}
