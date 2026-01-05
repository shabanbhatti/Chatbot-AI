import 'package:chatbot_ai/core/enum/color_accent_enum.dart';

String getAccentText(AccentColors color) {
  switch (color) {
    case AccentColors.red:
      return '🔴  Red';
    case AccentColors.blue:
      return '🔵  Blue';
    case AccentColors.green:
      return '🟢  Green';
    case AccentColors.yellow:
      return '🟡  Yellow';

    default:
      return 'Default';
  }
}
