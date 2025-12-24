import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/widgets/shimmer%20effects%20widgets/text_shimmer_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showLoadingDialog(BuildContext context, {required String content}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: .center,
            children: [SpinKitWave(color: ColorConstants.appColor, size: 30)],
          ),
        ),
        content: Row(
          mainAxisAlignment: .center,
          children: [
            const SizedBox(height: 30),
            TextShimmerEffect(text: content, textSize: 17),
          ],
        ),
      );
    },
  );
}
