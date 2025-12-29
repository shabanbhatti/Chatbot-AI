import 'package:flutter/cupertino.dart';

void showCupertinoFullSheet(
  BuildContext context, {
  required Widget child,
  required String pageName,
}) {
  showCupertinoModalPopup(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.9;

      return Align(
        alignment: Alignment.bottomCenter,
        child: CupertinoPopupSurface(
          child: Container(
            height: height,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _topBarWidget(context, pageName),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _topBarWidget(BuildContext context, String pageTitle) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.07,
    color: CupertinoColors.transparent,
    child: Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              pageTitle,
              style: CupertinoTheme.of(
                context,
              ).textTheme.textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(CupertinoIcons.xmark_circle_fill),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
