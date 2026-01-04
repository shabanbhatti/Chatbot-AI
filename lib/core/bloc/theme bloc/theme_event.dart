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
  final bool isLight;
  const GetTheme({required this.isLight});
  @override
  List<Object?> get props => [isLight];
}
