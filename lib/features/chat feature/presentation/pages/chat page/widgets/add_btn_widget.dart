import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class AddBtnWidget extends StatelessWidget {
  const AddBtnWidget({super.key, required this.onTap});
  final OnPressed onTap;
  @override
  Widget build(BuildContext context) {
    var butnTheme = CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGrey6,
      darkColor: CupertinoColors.systemGrey6.withAlpha(40),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: ShapeDecoration(
          shape: const CircleBorder(
            side: BorderSide(width: 0.5, color: CupertinoColors.systemGrey),
          ),
          color: CupertinoDynamicColor.resolve(butnTheme, context),
        ),
        child: const Icon(
          CupertinoIcons.add,
          size: 20,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}
