import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomRadioBtns extends StatelessWidget {
  const CustomRadioBtns({
    super.key,
    required this.onTap1,
    required this.onTap2,
    required this.title1,
    required this.title2,
    required this.value,
  });
  final OnChanged onTap1;
  final OnChanged onTap2;
  final String title1;
  final String title2;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: CupertinoButton.filled(
            color: (value == title1)
                ? ColorConstants.appColor
                : CupertinoColors.inactiveGray,
            onPressed: () {
              onTap1(title1);
            },
            child: Text(title1),
          ),
        ),
        const Spacer(flex: 1),
        Expanded(
          flex: 10,
          child: CupertinoButton.filled(
            color: (value == title2)
                ? ColorConstants.appColor
                : CupertinoColors.inactiveGray,
            onPressed: () {
              onTap2(title2);
            },
            child: Text(title2),
          ),
        ),
      ],
    );
  }
}
