import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser();
  Future<bool> insertUser(UserEntity userEntity);
  Future<bool> deleteUser(int id);
  Future<bool> updateUser(UserEntity userEntity);
}
