import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';

class InsertChatRoomUsecase  {
  final ChatRepository chatRepository;
  const InsertChatRoomUsecase({required this.chatRepository});

  Future<bool> call(ChatRoomEntity chatRoomEntity)async{
    return await chatRepository.createChatRoom(chatRoomEntity);
  }
}