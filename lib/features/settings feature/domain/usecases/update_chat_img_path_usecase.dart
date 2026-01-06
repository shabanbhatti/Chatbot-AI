import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/repository/chat_bckgnd_img_paths_repository.dart';

class UpdateChatImgPathUsecase {
  final ChatBckgndImgPathsRepository chatBckgndImgPathsRepository;
  const UpdateChatImgPathUsecase({required this.chatBckgndImgPathsRepository});

  Future<bool> call(ChatBckgndImgPathsEntity chatBckgndImgPathEntity) async {
    return await chatBckgndImgPathsRepository.updateImages(
      chatBckgndImgPathEntity,
    );
  }
}
