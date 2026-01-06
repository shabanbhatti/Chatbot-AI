import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/update_user_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/user_repository.dart';

class UpdateUserUsecaseImpl implements UpdateUserUsecase {
  final UserRepository userRepository;
  const UpdateUserUsecaseImpl({required this.userRepository});
  @override
  Future<bool> call(UserEntity userEntity)async{
    return await userRepository.updateUser(userEntity);
  }
  
}