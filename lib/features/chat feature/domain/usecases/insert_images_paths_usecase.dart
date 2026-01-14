import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class InsertImagesPathsUsecase {
  final ChatRepository chatRepository;
  const InsertImagesPathsUsecase({required this.chatRepository});

  Future<bool> call(ImagePathsEntity imagePathEntity) async {
    return await chatRepository.insertImages(imagePathEntity);
  }
}
