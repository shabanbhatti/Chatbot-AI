import 'package:chatbot_ai/features/chat%20feature/data/models/chat_model.dart';
import 'package:chatbot_ai/features/initial%20features/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static AppDatabase? appDatabase;

  const AppDatabase._();

  factory AppDatabase() {
    appDatabase ??= AppDatabase._();
    return appDatabase!;
  }

  Future<Database> get database async {
    var path = await getDatabasesPath();
    var db = await openDatabase(
      join(path, 'ai_chatbot.db'),
      onCreate: (db, version) async {
        await db.execute(UserModel.createTableQuery);
        await db.execute(ChatModel.createTable);
      },
      version: 1,
    );
    return db;
  }
}
