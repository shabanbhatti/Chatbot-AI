import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ShowToast {
  static void basicToast({
    required String message,
    Color? color,
    int? duration = 2,
    ToastGravity? gravity,
  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color ?? ColorConstants.appColor,
      timeInSecForIosWeb: duration ?? 2,
      gravity: gravity ?? ToastGravity.TOP,
    );
  }
}
