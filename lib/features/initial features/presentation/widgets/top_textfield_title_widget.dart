import 'package:flutter/cupertino.dart';

class TopTextfieldTitleWidget extends StatelessWidget {
  const TopTextfieldTitleWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 5),
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
