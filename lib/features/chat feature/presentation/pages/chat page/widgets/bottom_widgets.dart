import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_state.dart';
import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/utils/get_accent_colors_util.dart';
import 'package:chatbot_ai/core/utils/model%20bottom%20sheet/bottom_sheet_ios_utils.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/add_btn_detail_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/widgets/chat_textfield_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/widgets/circle_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class BottomWidgets extends StatefulWidget {
  const BottomWidgets({
    super.key,
    required this.chatNotifier,
    required this.chatController,
    required this.onSend,
    required this.onMic,
    required this.chatApiBloc,
    required this.multiImagesNotifier,
  });
  final ValueNotifier<String> chatNotifier;
  final TextEditingController chatController;
  final OnPressed onSend;
  final OnPressed onMic;
  final ValueNotifier<List<String>> multiImagesNotifier;
  final ChatApiBloc chatApiBloc;

  @override
  State<BottomWidgets> createState() => _BottomWidgetsState();
}

class _BottomWidgetsState extends State<BottomWidgets> {
  final ValueNotifier<List<AssetEntity>> assetsEntity = ValueNotifier([]);
  final ValueNotifier<List<String>> selectedAssetIds = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.multiImagesNotifier,
      builder: (context, value, child) {
        return SizedBox(
          width: double.infinity,
          height: value.isEmpty ? 70 : 150,

          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: .min,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.multiImagesNotifier,
              builder: (context, value, child) {
                if (value.isNotEmpty) {
                  return Expanded(
                    flex: 10,
                    child: ValueListenableBuilder(
                      valueListenable: widget.multiImagesNotifier,
                      builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsetsGeometry.all(5),
                          child: GridView.builder(
                            itemCount: value.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 7,
                                ),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: CupertinoColors.inactiveGray,
                                ),

                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Image.file(
                                        File(value[index]),

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () async {
                                          var updated = value
                                              .where(
                                                (element) =>
                                                    element != value[index],
                                              )
                                              .toList();
                                          widget.multiImagesNotifier.value =
                                              updated;

                                          List<String> list = [
                                            ...selectedAssetIds.value,
                                          ];
                                          list.removeAt(index);

                                          selectedAssetIds.value = list;
                                        },
                                        child: const Icon(
                                          CupertinoIcons.minus_circle_fill,
                                          color: CupertinoColors.destructiveRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CircleBtnWidget(
                      onTap: () async {
                        showCupertinoFullSheet(
                          context,
                          child: AddBtnDetailWidget(
                            multiImgsPaths: widget.multiImagesNotifier,
                            assetsEntity: assetsEntity,
                            selectedAssetIds: selectedAssetIds,
                          ),
                          sheetHeightThroughMediaQuery: 0.4,
                          pageName: 'Ai Chatbot',
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(top: 5),
                      child: ChatTextfieldWidget(
                        micWidget: BlocBuilder<ChatApiBloc, ChatApiState>(
                          buildWhen: (previous, current) {
                            if (previous is InitialChatApi &&
                                current is LoadingChatApi) {
                              return true;
                            } else if (previous is LoadingChatApi &&
                                current is LoadedChatApi) {
                              return true;
                            } else if (previous is LoadedChatApi &&
                                current is LoadedChatApi) {
                              return previous.chatEntity != current.chatEntity;
                            } else if (current is ErrorChatApi) {
                              return true;
                            } else {
                              return false;
                            }
                          },
                          bloc: widget.chatApiBloc,
                          builder: (context, state) {
                            if (state is LoadingChatApi) {
                              return Padding(
                                padding: const EdgeInsetsGeometry.only(
                                  right: 2,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    widget.chatApiBloc.add(
                                      OnStopChatApiEvent(),
                                    );
                                  },
                                  child: const Icon(
                                    CupertinoIcons.stop_circle_fill,
                                    color: CupertinoColors.destructiveRed,
                                    size: 45,
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsetsGeometry.only(
                                  right: 10,
                                ),
                                child: BlocBuilder<VoiceBloc, VoiceState>(
                                  buildWhen: (previous, current) {
                                    if (current is IsSpeakingVoice) {
                                      return true;
                                    } else if (current is IsLoadingVoice) {
                                      return true;
                                    } else if (current is IsLoadedVoice) {
                                      return true;
                                    } else if (current is IsErrorVoice) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                  builder: (context, state) {
                                    return state is IsSpeakingVoice
                                        ? BlocBuilder<
                                            AccentColorBloc,
                                            AccentColorState
                                          >(
                                            buildWhen: (previous, current) {
                                              if (previous.colorName !=
                                                  current.colorName) {
                                                return true;
                                              } else {
                                                return false;
                                              }
                                            },
                                            builder: (context, state) {
                                              return AvatarGlow(
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                curve: Curves.easeOutCirc,
                                                glowColor:
                                                    state.colorName ==
                                                        '⚪️  Default'
                                                    ? ColorConstants.appColor
                                                    : getAccentColor(
                                                        state.colorName,
                                                        withOpacity: false,
                                                      ),
                                                child: const Icon(
                                                  CupertinoIcons.mic,
                                                  size: 30,
                                                  color: CupertinoColors
                                                      .systemGrey,
                                                ),
                                              );
                                            },
                                          )
                                        : (state is IsLoadingVoice)
                                        ? const CupertinoActivityIndicator()
                                        : (state is IsLoadedVoice)
                                        ? const Icon(
                                            CupertinoIcons.mic,
                                            size: 25,
                                            color: CupertinoColors.systemGrey,
                                          )
                                        : const Icon(
                                            CupertinoIcons.mic,
                                            size: 30,
                                            color: CupertinoColors.systemGrey,
                                          );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        controller: widget.chatController,

                        onChanged: (value) {
                          widget.chatNotifier.value = value;
                        },
                        onMic:
                            (context.read<VoiceBloc>().state is IsLoadingVoice)
                            ? () {}
                            : widget.onMic,
                        onSend: () {
                          widget.onSend();
                          selectedAssetIds.value = [];
                        },
                        chatNotifier: widget.chatNotifier,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
