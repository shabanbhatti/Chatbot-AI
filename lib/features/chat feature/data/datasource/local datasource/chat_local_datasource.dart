import 'package:chatbot_ai/core/database/app_database.dart';
import 'package:chatbot_ai/features/chat%20feature/data/models/chat_model.dart';

abstract class ChatLocalDatasource {
  Future<List<ChatModel>> getChat(int id);
  Future<bool> insertChat(ChatModel chatModel);
  Future<bool> updateChat(ChatModel chatModel);
  Future<List<ChatRoomModel>> getChatRooms();
  Future<bool> createChatRoom(ChatRoomModel chatRoomModel);
  Future<bool> updateChatRoom(ChatRoomModel chatRoomModel);
  Future<bool> deleteChatRoom(int id);
  Future<List<ImagePathsModel>> getImgsPath(int id);
  Future<bool> insertImages(ImagePathsModel imagePathsModel);
}

class ChatLocalDatasourceImpl implements ChatLocalDatasource {
  final AppDatabase appDatabase;
  const ChatLocalDatasourceImpl({required this.appDatabase});

  @override
  Future<List<ChatModel>> getChat(int id) async {
    var db = await appDatabase.database;
    var data = await db.query(
      ChatModel.tableName,
      where: '${ChatModel.col_allChatId}=?',
      whereArgs: [id],
    );
    if (data.isNotEmpty) {
      return data.map((e) => ChatModel.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> insertChat(ChatModel chatModel) async {
    var db = await appDatabase.database;
    var isRowEffected = await db.insert(ChatModel.tableName, chatModel.toMap());
    return isRowEffected > 0;
  }

  @override
  Future<bool> updateChat(ChatModel chatModel) async {
    var db = await appDatabase.database;
    var isRowEffected = await db.update(
      ChatModel.tableName,
      chatModel.toMap(),
      where: '${ChatModel.col_id}=?',
      whereArgs: [chatModel.id],
    );
    return isRowEffected > 0;
  }

  @override
  Future<bool> createChatRoom(ChatRoomModel chatRoomModel) async {
    var db = await appDatabase.database;
    var isInserted = await db.insert(
      ChatRoomModel.tableName,
      chatRoomModel.toMap(),
    );
    return isInserted > 0;
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    var db = await appDatabase.database;
    var data = await db.query(ChatRoomModel.tableName);
    return data.map((e) => ChatRoomModel.fromMap(e)).toList();
  }

  @override
  Future<bool> updateChatRoom(ChatRoomModel chatRoomModel) async {
    var db = await appDatabase.database;
    var data = await db.update(
      ChatRoomModel.tableName,
      chatRoomModel.toMap(),
      where: '${ChatRoomModel.col_id}=?',
      whereArgs: [chatRoomModel.id],
    );
    return data > 0;
  }

  @override
  Future<bool> deleteChatRoom(int id) async {
    var db = await appDatabase.database;
    var isDeleted = await db.delete(
      ChatRoomModel.tableName,
      where: '${ChatRoomModel.col_id}=?',
      whereArgs: [id],
    );
    return isDeleted > 0;
  }

  @override
  Future<List<ImagePathsModel>> getImgsPath(int id) async {
    var db = await appDatabase.database;
    var data = await db.query(
      ImagePathsModel.tableName,
      where: '${ImagePathsModel.col_wholeImgId}=?',
      whereArgs: [id],
    );
    return data.map((e) => ImagePathsModel.fromMap(e)).toList();
  }

  @override
  Future<bool> insertImages(ImagePathsModel imagePathsModel) async {
    var db = await appDatabase.database;
    var isInserted = await db.insert(
      ImagePathsModel.tableName,
      imagePathsModel.toMap(),
    );
    return isInserted > 0;
  }
}
