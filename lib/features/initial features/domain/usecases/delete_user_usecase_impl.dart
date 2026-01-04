import 'package:chatbot_ai/core/domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/user_repository.dart';

class DeleteUserUsecaseImpl implements DeleteUserUsecase {
  final UserRepository userRepository;
  const DeleteUserUsecaseImpl({required this.userRepository});

  @override
  Future<bool> call(int id) async {
    return await userRepository.deleteUser(id);
  }
}
