import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/shared domain/entity/user_entity.dart';
import 'package:chatbot_ai/features/initial features/data/datasource/local datasource/user_local_datasource.dart';
import 'package:chatbot_ai/features/initial features/data/models/user_model.dart';
import 'package:chatbot_ai/features/initial features/domain/repository/user_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource userLocalDatasource;

  const UserRepositoryImpl({required this.userLocalDatasource});

  @override
  Future<UserEntity> getUser() async {
    try {
      final userModel = await userLocalDatasource.getUser();
      return userModel.toEntity();
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> insertUser(UserEntity userEntity) async {
    try {
      final userModel = UserModel(
        id: userEntity.id,
        name: userEntity.name,
        dateOfBirth: userEntity.dateOfBirth,
        gender: userEntity.gender,
        country: userEntity.country,
        userImg: userEntity.userImg,
      );
      return await userLocalDatasource.insertUser(userModel);
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> updateUser(UserEntity userEntity) async {
    try {
      final userModel = UserModel(
        id: userEntity.id,
        name: userEntity.name,
        dateOfBirth: userEntity.dateOfBirth,
        gender: userEntity.gender,
        country: userEntity.country,
        userImg: userEntity.userImg,
      );
      return await userLocalDatasource.updateUser(userModel);
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }

  @override
  Future<bool> deleteUser(int id) async {
    try {
      return await userLocalDatasource.deleteUser(id);
    } on DatabaseException catch (e) {
      throw LocalDatabaseFailure(message: e.toString());
    }
  }
}
