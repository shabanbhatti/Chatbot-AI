import 'package:chatbot_ai/core/constants/custom_theme_control_constants.dart';
import 'package:flutter/cupertino.dart';

void showCupertinoFullSheet(
  BuildContext context, {
  required Widget child,
  required String pageName,
  double sheetHeightThroughMediaQuery = 0.9,
}) {
  showCupertinoModalPopup(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final mediaQuery = MediaQuery.of(context);

      final height = mediaQuery.size.height * sheetHeightThroughMediaQuery;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CupertinoPopupSurface(
            child: Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CupertinoDynamicColor.resolve(
                  CustomThemeControl.bottomSheetColor,
                  context,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(0),
                ),
              ),
              child: Column(
                children: [
                  _topBarWidget(context, pageName),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _topBarWidget(
  BuildContext context,
  String pageTitle, {
  num sheetHeightThroughMediaQuery = 0.07,
}) {
  return Container(
    height: MediaQuery.of(context).size.height * sheetHeightThroughMediaQuery,
    color: CupertinoColors.transparent,
    child: Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
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
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(CupertinoIcons.xmark_circle_fill),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
