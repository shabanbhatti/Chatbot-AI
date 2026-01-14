import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewChatPrefBloc extends Bloc<NewChatPrefEvent, bool> {
  final SharedPreferencesService sharedPreferencesService;
  NewChatPrefBloc({required this.sharedPreferencesService}) : super(false) {
    on<GetNewChatBoolPref>((event, emit) async {
      var value = await sharedPreferencesService.getBool(
        SharedPreferencesKEYS.newChatKey,
      );
      emit(value);
    });
    on<SetNewChatboolPrefEvent>((event, emit) async {
      await sharedPreferencesService.setBool(
        SharedPreferencesKEYS.newChatKey,
        event.value,
      );
      // add(GetNewChatBoolPref());
      emit(event.value);
    });
  }
}
