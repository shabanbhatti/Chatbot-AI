import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';

abstract class UpdateUserUsecase {
  Future<bool> call(UserEntity userEntity);
}
