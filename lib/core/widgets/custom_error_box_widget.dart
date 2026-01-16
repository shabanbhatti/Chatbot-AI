import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_app_btn.dart';
import 'package:flutter/cupertino.dart';

class CustomErrorBoxWidget extends StatelessWidget {
  const CustomErrorBoxWidget({
    super.key,
    required this.exceptionMessage,
    required this.onRetry,
    required this.onClose,
  });
  final String exceptionMessage;
  final OnPressed onRetry;
  final OnPressed onClose;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: CupertinoColors.systemRed.withAlpha(50),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: .spaceEvenly,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsetsGeometry.only(right: 30, left: 10),
                  child: Text(
                    exceptionMessage,
                    style: CupertinoTheme.of(context).textTheme.textStyle
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.destructiveRed,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomAppBtn(
                      title: 'Retry',
                      onTap: onRetry,
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsetsGeometry.all(5),
                child: GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    CupertinoIcons.xmark_circle,
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
