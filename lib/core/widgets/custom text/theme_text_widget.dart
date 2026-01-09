import 'package:flutter/cupertino.dart';

class ThemeTextWidget extends StatelessWidget {
  const ThemeTextWidget({
    super.key,
    required this.text,
    this.size,
    this.fontWeight,
    this.color,
  });
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: size ?? 15,

        color: (color == null) ? null : color,
      ),
    );
  }
}
