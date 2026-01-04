import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomBasicListtile extends StatelessWidget {
  const CustomBasicListtile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.trailing,
    required this.onTap,
  });
  final IconData leadingIcon;
  final String title;
  final Widget? trailing;
  final OnPressed? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: onTap,
      leading: Icon(leadingIcon),
      title: Text(title),
      trailing: trailing ?? const SizedBox(),
    );
  }
}
