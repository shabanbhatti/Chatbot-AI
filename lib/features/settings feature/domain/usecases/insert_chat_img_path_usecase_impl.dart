import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_chat_bckgnd_img_paths_usecae.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/repository/chat_bckgnd_img_paths_repository.dart';

class InsertChatImgPathUsecaseImpl implements InsertChatBckgndImgPathsUsecae {
  final ChatBckgndImgPathsRepository chatBckgndImgPathsRepository;
  const InsertChatImgPathUsecaseImpl({
    required this.chatBckgndImgPathsRepository,
  });
  @override
  Future<bool> call(ChatBckgndImgPathsEntity chatBckgndImgPathsEntity) async {
    return await chatBckgndImgPathsRepository.insertImages(
      chatBckgndImgPathsEntity,
    );
  }
}
