import 'dart:async';

import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_event.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_state.dart';
import 'package:chatbot_ai/core/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
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
      emit(ThemeState(theme: darkTheme, themeDarkLight: ThemeDarkLight.dark));
    } else {
      print('CALLED');
      emit(ThemeState(theme: lightTheme, themeDarkLight: ThemeDarkLight.light));
    }
  }

  Future<void> onGetTheme(GetTheme event, Emitter<ThemeState> emit) async {
    if (event.isLight) {
      emit(ThemeState(theme: lightTheme, themeDarkLight: ThemeDarkLight.light));
    } else {
      emit(ThemeState(theme: darkTheme, themeDarkLight: ThemeDarkLight.dark));
    }
  }
}
