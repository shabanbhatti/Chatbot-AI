import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class SendPromptUsecase {
  final ChatRepository chatRepository;
  const SendPromptUsecase({required this.chatRepository});

  Future<ChatEntity> call(ChatEntity chatEntity) async {
    return await chatRepository.sendPrompt(chatEntity);
  }
}
