import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_state.dart';
import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/utils/get_accent_colors_util.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatBoxWidget extends StatelessWidget {
  const ChatBoxWidget({
    super.key,
    required this.isUser,
    required this.message,
    required this.onFavTap,
    required this.isFav,
  });
  final bool isUser;
  final String message;
  final OnPressed onFavTap;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: isUser ? 30 : 0, top: 6, bottom: 10),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: BlocBuilder<AccentColorBloc, AccentColorState>(
              buildWhen: (previous, current) {
                if (previous.colorName != current.colorName) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                return Container(
                  padding: isUser
                      ? const EdgeInsets.all(12)
                      : EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: isUser ? getAccentColor(state.colorName) : null,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: GptMarkdown(
                    message,
                    style: CupertinoTheme.of(context).textTheme.textStyle
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                );
              },
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
            if (!isUser)
              Padding(
                padding: EdgeInsetsGeometry.only(left: 10),
                child: GestureDetector(
                  onTap: onFavTap,
                  child: (!isFav)
                      ? const Icon(CupertinoIcons.heart, size: 15)
                      : const Icon(
                          CupertinoIcons.heart_fill,
                          color: CupertinoColors.destructiveRed,
                          size: 15,
                        ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
