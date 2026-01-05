import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_event.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_state.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccentColorBloc extends Bloc<AccentColorEvent, AccentColorState> {
  final SharedPreferencesService sharedPreferencesService;

  AccentColorBloc({required this.sharedPreferencesService})
    : super(AccentColorState(colorName: 'Default')) {
    on<SetColorEvent>((event, emit) async {
      await sharedPreferencesService.setString(event.key, event.value);
      add(GetColorEvent());
    });

    on<GetColorEvent>((event, emit) async {
      var value = await sharedPreferencesService.getString(
        SharedPreferencesKEYS.accentColorKey,
      );
      if (value.isEmpty) {
        emit(AccentColorState(colorName: 'Default'));
      } else {
        emit(AccentColorState(colorName: value));
      }
    });
  }
}
