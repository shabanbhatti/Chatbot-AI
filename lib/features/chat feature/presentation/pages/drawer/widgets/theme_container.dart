import 'package:flutter/cupertino.dart';

class ThemeContainer extends StatelessWidget {
  const ThemeContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    required this.lightColor,
    required this.darkColor,
  });
  final Widget? child;
  final double? height;
  final double? width;
  final Color lightColor;
  final Color darkColor;
  @override
  Widget build(BuildContext context) {
    Color drawerColor = CupertinoDynamicColor.withBrightness(
      color: lightColor,
      darkColor: darkColor,
    );
    return Container(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(drawerColor, context),
      ),
      child: child ?? const SizedBox(),
    );
  }
}
