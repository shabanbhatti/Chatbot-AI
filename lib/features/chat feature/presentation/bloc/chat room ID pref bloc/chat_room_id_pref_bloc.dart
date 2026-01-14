import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomIdPrefBloc extends Bloc<ChatRoomIdPrefEvent, int> {
  final SharedPreferencesService sharedPreferencesService;
  ChatRoomIdPrefBloc({required this.sharedPreferencesService}) : super(0) {
    on<GetChatRoomIdPrefEvent>((event, emit) async {
      var value = await sharedPreferencesService.getInt(
        SharedPreferencesKEYS.chatRoomIdKey,
      );
      emit(value);
    });
    on<SetChatRoomIdPrefEvent>((event, emit) async {
      await sharedPreferencesService.setInt(
        SharedPreferencesKEYS.chatRoomIdKey,
        event.value,
      );
      add(GetChatRoomIdPrefEvent());
    });
  }
}
