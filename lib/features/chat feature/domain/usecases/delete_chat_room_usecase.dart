import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class DeleteChatRoomUsecase {
  final ChatRepository chatRepository;
  const DeleteChatRoomUsecase({required this.chatRepository});

  Future<bool> call(int id) async {
    return await chatRepository.deleteChatRoom(id);
  }
}
