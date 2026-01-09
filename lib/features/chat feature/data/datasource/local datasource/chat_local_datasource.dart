import 'package:chatbot_ai/core/database/app_database.dart';
import 'package:chatbot_ai/features/chat%20feature/data/models/chat_model.dart';

abstract class ChatLocalDatasource {
  Future<List<ChatModel>> getChat();
  Future<bool> insertChat(ChatModel chatModel);
  Future<bool> updateChat(ChatModel chatModel);
}

class ChatLocalDatasourceImpl implements ChatLocalDatasource {
  final AppDatabase appDatabase;
  const ChatLocalDatasourceImpl({required this.appDatabase});

  @override
  Future<List<ChatModel>> getChat() async {
    var db = await appDatabase.database;
    var data = await db.query(ChatModel.tableName);
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
}
