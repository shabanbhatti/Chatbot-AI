import 'package:flutter/cupertino.dart';

abstract class CustomThemeControl {
  static Color drawerColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.inactiveGray.withAlpha(25),
    darkColor: CupertinoColors.darkBackgroundGray,
  );

  static Color bottomSheetColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.inactiveGray.withAlpha(25),
    darkColor: const Color.fromARGB(255, 23, 23, 23),
  );

  static Color outlinedBtnColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.secondaryLabel,
  );
}
