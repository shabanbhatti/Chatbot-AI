import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_state.dart';
import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/utils/get_accent_colors_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTextfieldWidget extends StatelessWidget {
  const ChatTextfieldWidget({
    super.key,
    required this.controller,
    required this.chatNotifier,
    this.onChanged,
    required this.onSend,
    required this.onMic,
    required this.micWidget,
  });
  final TextEditingController controller;
  final OnChangedOfTextField? onChanged;
  final ValueNotifier<String> chatNotifier;
  final OnPressed onSend;
  final OnPressed onMic;
  final Widget micWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: SizedBox(
        child: CupertinoTextField(
          controller: controller,

          onChanged: onChanged ?? (v) {},
          maxLines: 10,
          minLines: 1,
          placeholder: 'Ask anything',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          style: CupertinoTheme.of(context).textTheme.textStyle,
          placeholderStyle: CupertinoTheme.of(
            context,
          ).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey),
          suffix: ValueListenableBuilder(
            valueListenable: chatNotifier,
            builder: (context, value, child) {
              return (value.isEmpty)
                  ? Padding(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 5,
                      ),
                      child: CupertinoButton(
                        onPressed: onMic,
                        child: micWidget,
                      ),
                    )
                  : CupertinoButton(
                      onPressed: onSend,
                      child: BlocBuilder<AccentColorBloc, AccentColorState>(
                        buildWhen: (previous, current) {
                          if (previous.colorName != current.colorName) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          return Icon(
                            CupertinoIcons.arrow_up_circle_fill,
                            size: 25,
                            color: state.colorName == 'Default'
                                ? null
                                : getAccentColor(
                                    state.colorName,
                                    withOpacity: false,
                                  ),
                          );
                        },
                      ),
                    );
            },
          ),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: ColorConstants.dividerColor, width: 0.5),
          ),
        ),
      ),
    );
  }
}
