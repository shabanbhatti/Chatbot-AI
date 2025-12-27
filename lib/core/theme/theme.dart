import 'package:flutter/cupertino.dart';

var lightTheme = CupertinoThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: CupertinoColors.white,
  primaryColor: CupertinoColors.systemGrey,
);

var darkTheme = CupertinoThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: CupertinoColors.black,
  primaryColor: CupertinoColors.systemGrey,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(color: CupertinoColors.white),
  ),
);
