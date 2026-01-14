import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomBasicTextfield extends StatelessWidget {
  const CustomBasicTextfield({
    super.key,
    required this.controller,
    required this.title,
    this.prefixIcon,
    this.onChanged,
    this.readOnly,
    this.onTap,
    this.placeHolderSize,
  });
  final TextEditingController controller;
  final String title;
  final bool? readOnly;
  final IconData? prefixIcon;
  final OnChangedOfTextField? onChanged;
  final OnPressed? onTap;
  final double? placeHolderSize;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      onTap: onTap ?? () {},
      readOnly: readOnly ?? false,
      controller: controller,
      onChanged: onChanged ?? (v) {},
      prefix: (prefixIcon == null)
          ? null
          : Padding(
              padding: EdgeInsetsGeometry.only(left: 10),
              child: Icon(prefixIcon),
            ),

      placeholder: title,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      style: CupertinoTheme.of(context).textTheme.textStyle,
      placeholderStyle: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
        color: CupertinoColors.systemGrey,
        fontSize: placeHolderSize ?? 15,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CupertinoColors.systemGrey4, width: 0.8),
      ),
    );
  }
}
