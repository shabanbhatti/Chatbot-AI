import 'dart:async';

import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_event.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_state.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferencesService sharedPreferencesService;
  ThemeBloc({required this.sharedPreferencesService})
    : super(
        ThemeState(theme: lightTheme, themeDarkLight: ThemeDarkLight.light),
      ) {
    on<ToggeledTheme>(onToggeledTheme);
    on<GetTheme>(onGetTheme);
  }

  Future<void> onToggeledTheme(
    ToggeledTheme event,
    Emitter<ThemeState> emit,
  ) async {
    if (state.themeDarkLight == ThemeDarkLight.light) {
      await sharedPreferencesService.setBool(
        SharedPreferencesKEYS.themeKey,
        false,
      );
      emit(ThemeState(theme: darkTheme, themeDarkLight: ThemeDarkLight.dark));
    } else {
      await sharedPreferencesService.setBool(
        SharedPreferencesKEYS.themeKey,
        true,
      );
      emit(ThemeState(theme: lightTheme, themeDarkLight: ThemeDarkLight.light));
    }
  }

  Future<void> onGetTheme(GetTheme event, Emitter<ThemeState> emit) async {
    var value = await sharedPreferencesService.getBool(
      SharedPreferencesKEYS.themeKey,
    );

    if (value) {
      emit(ThemeState(theme: lightTheme, themeDarkLight: ThemeDarkLight.light));
    } else {
      emit(ThemeState(theme: darkTheme, themeDarkLight: ThemeDarkLight.dark));
    }
  }
}
