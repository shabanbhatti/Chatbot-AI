import 'package:flutter/cupertino.dart';

class CupertinoDivider extends StatelessWidget {
  const CupertinoDivider({super.key, this.color, this.thickness});
  final Color? color;
  final double? thickness;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness ?? 0.5,
      color: color ?? CupertinoColors.systemGrey,
    );
  }
}
