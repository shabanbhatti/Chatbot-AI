import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';

abstract class ChatBckgndImgPathsRepository {
  Future<List<ChatBckgndImgPathsEntity>> getImages();
  Future<bool> insertImages(ChatBckgndImgPathsEntity chatBckgndImgPathEntity);
  Future<bool> deleteImages(int id);
  Future<bool> updateImages(ChatBckgndImgPathsEntity chatBckgndImgPathEntity);
}
