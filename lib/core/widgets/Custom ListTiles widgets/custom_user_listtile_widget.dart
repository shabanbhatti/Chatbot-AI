import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/show_img_circle_avatar_widget.dart';
import 'package:flutter/cupertino.dart';

class CustomUserListtileWidget extends StatelessWidget {
  const CustomUserListtileWidget({
    super.key,
    required this.username,
    required this.imgPath,
    this.onTap,
  });
  final String username;
  final String imgPath;
  final OnPressed? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: CupertinoColors.systemGrey),
        ),
      ),
      width: double.infinity,
      child: CupertinoButton(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        color: CupertinoColors.transparent,
        onPressed: onTap ?? () {},
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ShowImgCircleAvatarWidget(
                radius: 50,
                userName: username,
                imgPath: imgPath,
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 10,
              child: Text(
                username,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: CupertinoTheme.of(
                  context,
                ).textTheme.textStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
