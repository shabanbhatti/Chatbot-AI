import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_app_btn.dart';
import 'package:flutter/cupertino.dart';

class CustomErrorBoxWidget extends StatelessWidget {
  const CustomErrorBoxWidget({
    super.key,
    required this.exceptionMessage,
    required this.onRetry,
  });
  final String exceptionMessage;
  final OnPressed onRetry;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: CupertinoColors.systemRed.withAlpha(50),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: Text(
                exceptionMessage,
                style: const TextStyle(
                  color: CupertinoColors.destructiveRed,
                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
