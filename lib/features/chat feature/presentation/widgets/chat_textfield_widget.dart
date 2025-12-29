import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

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
                      child: Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        size: 25,
                        color:
                            CupertinoTheme.of(
                                  context,
                                ).scaffoldBackgroundColor ==
                                CupertinoColors.black
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                      ),
                    );
            },
          ),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
          ),
        ),
      ),
    );
  }
}
