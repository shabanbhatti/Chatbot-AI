import 'package:chatbot_ai/features/settings%20feature/domain/repository/chat_bckgnd_img_paths_repository.dart';

class DeleteChatImgPathsUsecase {
  final ChatBckgndImgPathsRepository chatBckgndImgPathsRepository;
  const DeleteChatImgPathsUsecase({required this.chatBckgndImgPathsRepository});

  Future<bool> call(int id) async {
    return await chatBckgndImgPathsRepository.deleteImages(id);
  }
}
