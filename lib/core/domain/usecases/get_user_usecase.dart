import 'package:chatbot_ai/core/domain/entity/user_entity.dart';

abstract class GetUserUsecase {
  Future<UserEntity> call();
}
