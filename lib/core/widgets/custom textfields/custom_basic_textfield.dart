import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

class CustomBasicTextfield extends StatelessWidget {
  const CustomBasicTextfield({
    super.key,
    required this.controller,
    required this.title,
    required this.prefixIcon,
    this.onChanged,
    this.readOnly,
    this.onTap,
  });
  final TextEditingController controller;
  final String title;
  final bool? readOnly;
  final IconData prefixIcon;
  final OnChangedOfTextField? onChanged;
  final OnPressed? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      onTap: onTap ?? () {},
      readOnly: readOnly ?? false,
      controller: controller,
      onChanged: onChanged ?? (v) {},
      prefix: Padding(
        padding: EdgeInsetsGeometry.only(left: 10),
        child: Icon(prefixIcon),
      ),
      placeholder: title,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      style: const TextStyle(fontSize: 16, color: CupertinoColors.black),
      placeholderStyle: const TextStyle(
        fontSize: 16,
        color: CupertinoColors.systemGrey,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CupertinoColors.systemGrey4, width: 0.8),
      ),
    );
  }
}
