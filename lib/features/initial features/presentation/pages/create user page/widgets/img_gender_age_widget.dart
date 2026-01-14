import 'package:awesome_shake_widget/shake_widget.dart';
import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/utils/image_picker_utils.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_app_btn.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/custom_circle_avatar_widget.dart';
import 'package:chatbot_ai/core/widgets/custom%20radio%20btns/custom_radio_btns.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/widgets/select_birth_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImgGenderAgeWidget extends StatelessWidget {
  const ImgGenderAgeWidget({
    super.key,
    required this.name,
    required this.imgPathNotifier,
    required this.birthController,
    required this.genderNotifier,
    required this.birthNotifier,
    required this.onCreate,
    required this.radioBtnsKey,
    required this.dateOfBirthKey,
  });
  final String name;
  final ValueNotifier<String?> imgPathNotifier;
  final ValueNotifier<String> genderNotifier;
  final TextEditingController birthController;
  final ValueNotifier<String> birthNotifier;
  final OnPressed onCreate;
  final GlobalKey<ShakeWidgetState> radioBtnsKey;
  final GlobalKey<ShakeWidgetState> dateOfBirthKey;

  @override
  Widget build(BuildContext context) {
    print('Gender img age page build');
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 20),
        ),
        SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: imgPathNotifier,
                builder: (context, value, child) {
                  return CustomCircleAvatarWidget(
                    userName: name,
                    imgPath: value ?? '',
                    onTakeImage: () async {
                      var imgPath = await getIt<ImagePickerUtils>().takeImage(
                        ImageSource.gallery,
                      );
                      if (imgPath != null) {
                        imgPathNotifier.value = imgPath;
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),

        SelectBirthWidget(
          birthController: birthController,
          birthNotifier: birthNotifier,
          dateOfBirthKey: dateOfBirthKey,
        ),

        SliverToBoxAdapter(
          child: ShakeWidget(
            key: radioBtnsKey,
            duration: const Duration(milliseconds: 500),
            child: ValueListenableBuilder(
              valueListenable: genderNotifier,
              builder: (context, value, child) {
                return CustomRadioBtns(
                  value: value,
                  onTap1: (value) {
                    genderNotifier.value = value;
                  },
                  onTap2: (value) {
                    genderNotifier.value = value;
                  },
                  title1: 'Male',
                  title2: 'Female',
                );
              },
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 15),
          sliver: SliverToBoxAdapter(
            child: CustomAppBtn(title: 'Create', onTap: onCreate),
          ),
        ),
      ],
    );
  }
}
