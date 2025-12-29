import 'dart:io';

import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/utils/extentions/get_first&last_initial_extension.dart';
import 'package:flutter/cupertino.dart';

class ShowImgCircleAvatarWidget extends StatelessWidget {
  const ShowImgCircleAvatarWidget({
    super.key,
    required this.radius,
    required this.userName,
    required this.imgPath,
  });
  final double radius;
  final String userName;
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: ColorConstants.appColor,
      ),
      alignment: Alignment.center,
      child: (imgPath == '')
          ? Text(
              userName.initials,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                color: CupertinoColors.extraLightBackgroundGray,
                fontSize: 20,
              ),
            )
          : Image.file(
              File(imgPath),
              fit: BoxFit.cover,
              height: radius,
              width: radius,
            ),
    );
  }
}
