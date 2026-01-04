import 'package:chatbot_ai/core/constants/custom_theme_control_constants.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomOutlinedBtn extends StatelessWidget {
  const CustomOutlinedBtn({
    super.key,
    this.height,
    this.width,
    required this.title,
    this.fontSize,
    required this.onTap,
  });
  final double? height;
  final double? width;
  final String title;
  final double? fontSize;
  final OnPressed onTap;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(
            CustomThemeControl.outlinedBtnColor,
            context,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: CupertinoTheme.of(
            context,
          ).textTheme.textStyle.copyWith(fontSize: fontSize ?? 15),
        ),
      ),
    );
  }
}
