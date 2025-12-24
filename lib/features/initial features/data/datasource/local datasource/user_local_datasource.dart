import 'package:chatbot_ai/core/database/app_database.dart';
import 'package:chatbot_ai/features/initial%20features/data/models/user_model.dart';

abstract class UserLocalDatasource {
  Future<UserModel> getUser();
  Future<bool> insertUser(UserModel userModel);
  Future<bool> deleteUser(int id);
  Future<bool> updateUser(UserModel userModel);
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  final AppDatabase appDatabase;

  const UserLocalDatasourceImpl(this.appDatabase);

  @override
  Future<bool> insertUser(UserModel userModel) async {
    final db = await appDatabase.database;
    final result = await db.insert(UserModel.tableName, userModel.toMap());
    return result > 0;
  }

  @override
  Future<UserModel> getUser() async {
    final db = await appDatabase.database;
    final result = await db.query(UserModel.tableName, limit: 1);

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }

    throw Exception('No user found in local database');
  }

  @override
  Future<bool> deleteUser(int id) async {
    final db = await appDatabase.database;
    final result = await db.delete(
      UserModel.tableName,
      where: '${UserModel.colId} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<bool> updateUser(UserModel userModel) async {
    final db = await appDatabase.database;
    final result = await db.update(
      UserModel.tableName,
      userModel.toMap(),
      where: '${UserModel.colId} = ?',
      whereArgs: [userModel.id],
    );
    return result > 0;
  }
}
