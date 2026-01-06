import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/repository/chat_bckgnd_img_paths_repository.dart';

class GetChatImgsPathsUsecase {
  final ChatBckgndImgPathsRepository chatBckgndImgPathsRepository;
  const GetChatImgsPathsUsecase({required this.chatBckgndImgPathsRepository});
  Future<List<ChatBckgndImgPathsEntity>> call() async {
    return await chatBckgndImgPathsRepository.getImages();
  }
}
