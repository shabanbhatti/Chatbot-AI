import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class GetChatRoomsUsecase  {
  final ChatRepository chatRepository;
  const GetChatRoomsUsecase({required this.chatRepository});

  Future<List<ChatRoomEntity>> call()async{
    return await chatRepository.getChatRooms();
  }
}