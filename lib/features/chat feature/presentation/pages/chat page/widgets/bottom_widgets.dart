import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/widgets/chat_textfield_widget.dart';
import 'package:flutter/cupertino.dart';

class BottomWidgets extends StatelessWidget {
  const BottomWidgets({
    super.key,
    required this.chatNotifier,
    required this.chatController,
    required this.onSend,
    required this.onMic,
  });
  final ValueNotifier<String> chatNotifier;
  final TextEditingController chatController;
  final OnPressed onSend;
  final OnPressed onMic;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                width: 50,
                decoration: ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(color: CupertinoColors.systemGrey4),
                  ),
                  color: CupertinoColors.systemGrey.withAlpha(50),
                ),
                child: Icon(
                  CupertinoIcons.add,
                  size: 20,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 5),
                child: ChatTextfieldWidget(
                  controller: chatController,
                  onChanged: (value) {
                    chatNotifier.value = value;
                  },
                  onMic: () {},
                  onSend: onSend,
                  chatNotifier: chatNotifier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
