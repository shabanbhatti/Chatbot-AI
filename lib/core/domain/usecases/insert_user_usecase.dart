import 'package:chatbot_ai/core/domain/entity/user_entity.dart';

abstract class InsertUserUsecase {
  Future<bool> call(UserEntity userEntity);
}
