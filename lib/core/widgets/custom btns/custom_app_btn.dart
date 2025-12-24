import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomAppBtn extends StatelessWidget {
  const CustomAppBtn({super.key, required this.title, required this.onTap});
  final String title;
  final OnPressed onTap;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      color: ColorConstants.appColor,
      onPressed: onTap,
      child: Text(title),
    );
  }
}
