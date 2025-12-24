import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_event.dart';
import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_state.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharedPreferencesBloc
    extends Bloc<SharedPreferencesEvent, SharedPreferencesState> {
  final SharedPreferencesService sharedPreferencesService;

  SharedPreferencesBloc({required this.sharedPreferencesService})
    : super(SharedPreferencesState(boolValue: false)) {
    on<GetBoolEvent>((event, emit) async {
      var value = await sharedPreferencesService.getBool(event.key);
      emit(SharedPreferencesState(boolValue: value));
    });

    on<SetBoolEvent>((event, emit) async {
      await sharedPreferencesService.setBool(event.key, event.value);
    });
  }
}
