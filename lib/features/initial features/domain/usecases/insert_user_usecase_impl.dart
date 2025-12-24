import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/user_repository.dart';

class InsertUserUsecaseImpl implements InsertUserUsecase {
  final UserRepository userRepository;
  const InsertUserUsecaseImpl({required this.userRepository});
  @override
  Future<bool> call(UserEntity userEntity) async {
    return await userRepository.insertUser(userEntity);
  }
}
