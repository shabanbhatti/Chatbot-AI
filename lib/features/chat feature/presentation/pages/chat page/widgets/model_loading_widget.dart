import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ModelLoadingWidget extends StatelessWidget {
  const ModelLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 23),
      child: Row(
        mainAxisAlignment: .start,
        children: [SpinKitWave(color: ColorConstants.appColor, size: 20)],
      ),
    );
  }
}
