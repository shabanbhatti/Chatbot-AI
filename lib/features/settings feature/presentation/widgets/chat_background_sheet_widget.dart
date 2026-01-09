import 'dart:developer';
import 'dart:io';

import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/utils/image_picker_utils.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_bloc.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_event.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatBackgroundSheetWidget extends StatelessWidget {
  const ChatBackgroundSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    log('CHAT BACKGROUND WALLPAPER PAGE BUILD CALLED');
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            BlocBuilder<SettingBloc, SettingState>(
              buildWhen: (previous, current) {
                if (previous is InitialSettingState &&
                    current is LoadingSettingState) {
                  return true;
                } else if (previous is LoadingSettingState &&
                    current is LoadedSettingState) {
                  return true;
                } else if (previous is LoadedSettingState &&
                    current is LoadedSettingState) {
                  return previous.chatImgPaths != current.chatImgPaths;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is LoadingSettingState) {
                  return const SliverFillRemaining(
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                } else if (state is LoadedSettingState) {
                  var list = state.chatImgPaths ?? [];
                  return _loadedWidget(list);
                } else {
                  return const SliverToBoxAdapter();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _loadedWidget(List<ChatBckgndImgPathsEntity> list) {
  return SliverGrid.builder(
    itemCount: list.length + 2,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 0.7,
    ),
    itemBuilder: (context, index) {
      bool isAnyActive = list.any((e) {
        return e.isActive;
      });
      if (index == 0) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: CupertinoButton(
            onPressed: () async {
              var path = await getIt<ImagePickerUtils>().takeImage(
                ImageSource.gallery,
              );
              if (path != null) {
                context.read<SettingBloc>().add(
                  InsertChatBackgroundImagePathEvent(
                    chatBckgndImgPathsEntity: ChatBckgndImgPathsEntity(
                      imgPaths: path,
                      isActive: false,
                      id: DateTime.now().microsecondsSinceEpoch,
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(width: 3, color: CupertinoColors.white),
                ),
                color: CupertinoColors.transparent,
              ),
              child: const Icon(
                CupertinoIcons.camera_fill,
                color: CupertinoColors.white,
              ),
            ),
          ),
        );
      }

      if (index == 1) {
        print('====');
        return Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () async {
              context.read<SettingBloc>().add(
                UpdateChatBackgroundImagePathEvent(chatBckgndEntityList: list),
              );
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: (!isAnyActive)
                    ? Border.all(color: CupertinoColors.activeGreen, width: 3)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                'Default',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }

      final data = list[index - 2];

      return Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () async {
            context.read<SettingBloc>().add(
              UpdateChatBackgroundImagePathEvent(
                chatBckgndEntityList: list,
                chatBckgndImgPathsEntity: ChatBckgndImgPathsEntity(
                  imgPaths: data.imgPaths,
                  isActive: true,
                  id: data.id,
                ),
              ),
            );
          },
          child: SizedBox(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: (data.isActive)
                        ? Border.all(
                            color: CupertinoColors.activeGreen,
                            width: 3,
                          )
                        : null,
                  ),
                  child: (data.imgPaths.startsWith('assets/'))
                      ? Image.asset(data.imgPaths, fit: BoxFit.cover)
                      : Image.file(File(data.imgPaths), fit: BoxFit.cover),
                ),
                if (!data.imgPaths.startsWith('assets/'))
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Icon(
                        CupertinoIcons.minus_circle_fill,
                        color: CupertinoColors.destructiveRed,
                      ),
                      onTap: () => context.read<SettingBloc>().add(
                        DeleteChatbackgroundImagesEvent(
                          chatBckgndImgEntity: data,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
