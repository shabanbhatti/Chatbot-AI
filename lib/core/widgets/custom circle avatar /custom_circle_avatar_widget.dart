import 'dart:io';

import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomCircleAvatarWidget extends StatelessWidget {
  const CustomCircleAvatarWidget({
    super.key,
    this.radius = 150,
    required this.userName,
    required this.imgPath,
    required this.onTakeImage,
  });
  final double radius;
  final String userName;
  final String imgPath;
  final OnPressed onTakeImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: Stack(
        children: [
          Container(
            height: radius,
            width: radius,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: CupertinoColors.systemPink,
            ),
            alignment: Alignment.center,
            child: (imgPath == '')
                ? Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.extraLightBackgroundGray,
                    ),
                  )
                : Image.file(
                    File(imgPath),
                    fit: BoxFit.cover,
                    height: radius,
                    width: radius,
                  ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: onTakeImage,
              child: Container(
                height: 50,
                width: 50,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: CupertinoColors.white,
                ),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.black,
                  size: 27,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
