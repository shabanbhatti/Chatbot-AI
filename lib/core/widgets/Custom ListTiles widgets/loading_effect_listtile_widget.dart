import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/show_img_circle_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingUserListtileEffectWidget extends StatelessWidget {
  const LoadingUserListtileEffectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey5,
      highlightColor: CupertinoColors.systemGrey4,
      direction: ShimmerDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 60,
        child: const Row(
          children: [
            ShowImgCircleAvatarWidget(
              radius: 50,
              userName: 'userName',
              imgPath: '',
            ),

            SizedBox(width: 12),

            // Text skeleton
            Expanded(
              child: Skeletonizer(child: Text('Muhammad Shaban Abubakkar')),
            ),
          ],
        ),
      ),
    );
  }
}
