import 'package:equatable/equatable.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

class ToggeledTheme extends ThemeEvent {
  const ToggeledTheme();
}

class GetTheme extends ThemeEvent {
  const GetTheme();
  @override
  List<Object?> get props => [];
}
