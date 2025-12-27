import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatBoxWidget extends StatelessWidget {
  const ChatBoxWidget({super.key, required this.isUser, required this.message});
  final bool isUser;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: isUser ? 30 : 0, top: 6, bottom: 6),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? CupertinoColors.inactiveGray.withAlpha(100)
                    : null,
                borderRadius: BorderRadius.circular(18),
              ),
              child: GptMarkdown(
                message,
                // textDirection: TextDirection.ltr,
                // textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: isUser ? .end : .start,
          children: [
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: message));
                HapticFeedback.lightImpact();

                ShowToast.basicToast(
                  message: 'Copied',
                  color: ColorConstants.appColor,
                );
              },
              child: const Icon(CupertinoIcons.square_on_square, size: 15),
            ),
          ],
        ),
      ],
    );
  }
}
