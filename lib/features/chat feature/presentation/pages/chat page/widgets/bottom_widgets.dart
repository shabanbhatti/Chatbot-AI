import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/add_btn_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/widgets/chat_textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Expanded(flex: 2, child: AddBtnWidget(onTap: () {})),
            Expanded(
              flex: 15,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 5),
                child: BlocBuilder<VoiceBloc, VoiceState>(
                  builder: (context, state) {
                    return ChatTextfieldWidget(
                      micWidget: state.isSpeaking
                          ? AvatarGlow(
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeOutCirc,
                              glowColor: ColorConstants.appColor,
                              child: const Icon(
                                CupertinoIcons.mic,
                                size: 25,
                                color: CupertinoColors.systemGrey,
                              ),
                            )
                          : (state.isLoading)
                          ? CupertinoActivityIndicator()
                          : (state.isLoaded)
                          ? const Icon(
                              CupertinoIcons.mic,
                              size: 25,
                              color: CupertinoColors.systemGrey,
                            )
                          : const Icon(
                              CupertinoIcons.mic,
                              size: 25,
                              color: CupertinoColors.systemGrey,
                            ),
                      controller: chatController,

                      onChanged: (value) {
                        chatNotifier.value = value;
                      },
                      onMic: (state.isLoading) ? () {} : onMic,
                      onSend: onSend,
                      chatNotifier: chatNotifier,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
