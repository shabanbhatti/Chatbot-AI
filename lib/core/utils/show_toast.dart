import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ShowToast {
  static void basicToast({
    required String message,
    Color? color,
    int? duration = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color ?? CupertinoColors.activeGreen,
      timeInSecForIosWeb: duration ?? 2,
      gravity: ToastGravity.TOP,
    );
  }
}
