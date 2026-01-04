import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum ThemeDarkLight { dark, light }

class ThemeState extends Equatable {
  final CupertinoThemeData theme;
  final ThemeDarkLight themeDarkLight;
  const ThemeState({required this.theme, required this.themeDarkLight});
  ThemeState copyWith({
    ThemeDarkLight? themeDarkLight,
    CupertinoThemeData? theme,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
      themeDarkLight: themeDarkLight ?? this.themeDarkLight,
    );
  }

  @override
  List<Object?> get props => [theme, themeDarkLight];
}
