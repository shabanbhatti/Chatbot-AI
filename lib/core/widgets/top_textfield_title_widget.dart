import 'package:flutter/cupertino.dart';

class TopTextfieldTitleWidget extends StatelessWidget {
  const TopTextfieldTitleWidget({
    super.key,
    required this.title,
    this.verticalSpace,
  });
  final String title;
  final double? verticalSpace;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: verticalSpace ?? 5,
        horizontal: 5,
      ),
      child: Row(
        children: [
          Text(
            '$title*',
            style: CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
