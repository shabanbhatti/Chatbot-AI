import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class TextShimmerEffect extends StatelessWidget {
  const TextShimmerEffect({super.key, required this.text, this.textSize});
  final String text;
  final double? textSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.black,
      highlightColor: CupertinoColors.systemGrey4,
      period: const Duration(milliseconds: 1500),
      child: Text(
        text,
        style: TextStyle(fontSize: textSize ?? 22, fontWeight: FontWeight.w600),
      ),
    );
  }
}
