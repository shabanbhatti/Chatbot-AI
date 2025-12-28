import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class AddBtnWidget extends StatelessWidget {
  const AddBtnWidget({super.key, required this.onTap});
  final OnPressed onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: ShapeDecoration(
          shape: const CircleBorder(
            side: BorderSide(width: 0.5, color: CupertinoColors.systemGrey),
          ),
          color: CupertinoColors.systemGrey.withAlpha(70),
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
