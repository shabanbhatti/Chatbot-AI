import 'package:chatbot_ai/core/domain/entity/user_entity.dart';
import 'package:chatbot_ai/core/domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/user_repository.dart';

class GetUserUsecaseImpl implements GetUserUsecase {
  final UserRepository userRepository;
  const GetUserUsecaseImpl({required this.userRepository});

  @override
  Future<UserEntity> call() async {
    return await userRepository.getUser();
  }
}
