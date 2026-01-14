import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class GetImagesPathsUsecase {
  final ChatRepository chatRepository;
  const GetImagesPathsUsecase({required this.chatRepository});

  Future<List<ImagePathsEntity>> call(int id) async {
    return chatRepository.getImgsPath(id);
  }
}
