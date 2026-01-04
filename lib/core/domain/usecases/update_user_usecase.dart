import 'package:chatbot_ai/core/domain/entity/user_entity.dart';

abstract class UpdateUserUsecase {
  Future<bool> call(UserEntity userEntity);
}
