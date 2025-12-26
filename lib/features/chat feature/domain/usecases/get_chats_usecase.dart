import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class GetChatsUsecase {
  final ChatRepository chatRepository;
  const GetChatsUsecase({required this.chatRepository});
  Future<List<ChatEntity>> call() async {
    return await chatRepository.getChat();
  }
}
