import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CircleBtnWidget extends StatelessWidget {
  const CircleBtnWidget({
    super.key,
    required this.onTap,
    this.icon,
    this.radius = 50,
  });
  final OnPressed onTap;
  final IconData? icon;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    var butnTheme = CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGrey6,
      darkColor: const Color.fromARGB(255, 29, 29, 29),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: radius,
        width: radius,
        decoration: ShapeDecoration(
          shape: const CircleBorder(
            side: BorderSide(width: 0.5, color: CupertinoColors.systemGrey),
          ),
          color: CupertinoDynamicColor.resolve(butnTheme, context),
        ),
        child: Icon(
          icon ?? CupertinoIcons.add,
          size: 20,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}
