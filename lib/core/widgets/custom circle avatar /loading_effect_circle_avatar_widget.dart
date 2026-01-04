import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class LoadingEffectCircleAvatarWidget extends StatelessWidget {
  const LoadingEffectCircleAvatarWidget({super.key, this.radius = 150});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey5,
      highlightColor: CupertinoColors.systemGrey4,
      direction: ShimmerDirection.ltr,
      child: SizedBox(
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
            ),

            Align(
              alignment: Alignment.bottomRight,
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
          ],
        ),
      ),
    );
  }
}
