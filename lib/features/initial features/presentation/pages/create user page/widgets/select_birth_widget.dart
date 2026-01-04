import 'package:chatbot_ai/core/constants/custom_theme_control_constants.dart';
import 'package:chatbot_ai/core/utils/date_format_util.dart';
import 'package:chatbot_ai/core/widgets/custom%20textfields/custom_basic_textfield.dart';
import 'package:chatbot_ai/core/widgets/custom_divider_widget.dart';
import 'package:chatbot_ai/core/widgets/top_textfield_title_widget.dart';
import 'package:flutter/cupertino.dart';

class SelectBirthWidget extends StatelessWidget {
  const SelectBirthWidget({
    super.key,
    required this.birthController,
    required this.birthNotifier,
  });
  final TextEditingController birthController;
  final ValueNotifier<String> birthNotifier;
  @override
  Widget build(BuildContext context) {
    print('Date of birth widget called');
    return SliverPadding(
      padding: const EdgeInsetsGeometry.only(top: 20, bottom: 10),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const TopTextfieldTitleWidget(title: 'Date of birth'),
            CustomBasicTextfield(
              controller: birthController,

              title: 'Select Date of birth',
              prefixIcon: CupertinoIcons.calendar,
              readOnly: true,
              onTap: () async {
                showCupertinoModalPopup(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => Container(
                    decoration: BoxDecoration(
                      color: CupertinoDynamicColor.resolve(
                        CustomThemeControl.bottomSheetColor,
                        context,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              top: 15,
                              right: 15,
                              left: 15,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    birthNotifier.value = '';
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .copyWith(
                                          color: CupertinoColors.systemRed,
                                        ),
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: birthNotifier,
                                  builder: (context, value, child) {
                                    return Text(
                                      value,
                                      style: CupertinoTheme.of(
                                        context,
                                      ).textTheme.textStyle,
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: birthNotifier,
                                  builder: (context, value, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        birthController.text = value;
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Confirm',

                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .textStyle
                                            .copyWith(
                                              color: CupertinoColors.activeBlue,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const CupertinoDivider(thickness: 0.5),
                          Container(
                            height: 200,

                            color: CupertinoDynamicColor.resolve(
                              CustomThemeControl.bottomSheetColor,
                              context,
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              maximumDate: DateTime.now(),
                              initialDateTime: DateTime(2000),
                              onDateTimeChanged: (date) {
                                var format = DateFormatUtil.formatDate(date);
                                birthController.text = format;
                                birthNotifier.value = format;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
