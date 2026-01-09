import 'package:flutter/cupertino.dart';

abstract class CustomThemeControl {
  // static

  static Color bottomSheetColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.inactiveGray.withAlpha(25),
    darkColor: const Color.fromARGB(255, 22, 22, 22),
  );

  static Color outlinedBtnColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.secondaryLabel,
  );
}
