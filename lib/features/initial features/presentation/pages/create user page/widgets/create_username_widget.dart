import 'package:awesome_shake_widget/enum/shake_preset.dart';
import 'package:awesome_shake_widget/shake_widget.dart';
import 'package:chatbot_ai/core/constants/image_path_constants.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_app_btn.dart';
import 'package:chatbot_ai/core/widgets/custom%20textfields/custom_basic_textfield.dart';
import 'package:chatbot_ai/core/widgets/top_textfield_title_widget.dart';
import 'package:flutter/cupertino.dart';

class CreateUserNameWidget extends StatelessWidget {
  const CreateUserNameWidget({
    super.key,
    required this.controller,
    required this.onNext,
    required this.shakeWidgetKey,
  });
  final TextEditingController controller;
  final OnPressed onNext;
  final GlobalKey<ShakeWidgetState> shakeWidgetKey;
  @override
  Widget build(BuildContext context) {
    print('name widget called');
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 20),
        ),
        SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
          sliver: SliverToBoxAdapter(
            child: Hero(
              tag: 'move',
              child: Image.asset(
                ImagePathConstants.appLogo,
                height: 150,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
          sliver: SliverToBoxAdapter(
            child: ShakeWidget(
              key: shakeWidgetKey,
              duration: const Duration(milliseconds: 500),
              preset: ShakePreset.custom,
              child: Column(
                children: [
                  const TopTextfieldTitleWidget(title: 'Name'),
                  CustomBasicTextfield(
                    controller: controller,
                    title: 'Name',
                    prefixIcon: CupertinoIcons.person_fill,
                  ),
                ],
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 0),
          sliver: SliverToBoxAdapter(
            child: CustomAppBtn(title: 'Next', onTap: onNext),
          ),
        ),
      ],
    );
  }
}
