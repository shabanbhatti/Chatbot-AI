import 'package:flutter/cupertino.dart';

Color getAccentColor(String colorName, {bool withOpacity = true}) {
  switch (colorName) {
    case '🔴  Red':
      return (withOpacity)
          ? CupertinoColors.systemRed.withAlpha(100)
          : CupertinoColors.systemRed;
    case '🔵  Blue':
      return (withOpacity)
          ? CupertinoColors.activeBlue.withAlpha(100)
          : CupertinoColors.activeBlue;
    case '🟢  Green':
      return (withOpacity)
          ? CupertinoColors.activeGreen.withAlpha(100)
          : CupertinoColors.activeGreen;
    case '🟡  Yellow':
      return (withOpacity)
          ? CupertinoColors.systemYellow.withAlpha(100)
          : CupertinoColors.systemYellow;

    default:
      return (withOpacity)
          ? CupertinoColors.systemGrey2.withAlpha(100)
          : CupertinoColors.systemGrey2;
  }
}
