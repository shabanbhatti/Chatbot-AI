import 'package:flutter/cupertino.dart';

var lightTheme = CupertinoThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: CupertinoColors.white,
  primaryColor: CupertinoColors.black,

  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(
      color: CupertinoColors.darkBackgroundGray,
      fontWeight: FontWeight.normal,
      fontSize: 15,
    ),
  ),
);

var darkTheme = CupertinoThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: CupertinoColors.black,
  primaryColor: CupertinoColors.white,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(color: CupertinoColors.white, fontSize: 15),
  ),
);
