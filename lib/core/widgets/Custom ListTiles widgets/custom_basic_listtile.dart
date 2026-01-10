import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:cupertino_native/components/icon.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

class CustomBasicListtile extends StatelessWidget {
  const CustomBasicListtile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.cupertinoIcon,
  });
  final IconData leadingIcon;
  final String title;
  final Widget? trailing;
  final OnPressed? onTap;
  final CNIcon? cupertinoIcon;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: onTap,
      leading: cupertinoIcon ?? Icon(leadingIcon),
      title: Text(title),
      trailing: trailing ?? const SizedBox(),
    );
  }
}
