import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class InsertChatUsecase {
  final ChatRepository chatRepository;
  const InsertChatUsecase({required this.chatRepository});

  Future<bool> call(ChatEntity chatEntity) async {
    return await chatRepository.insertChat(chatEntity);
  }
}
