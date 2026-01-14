import 'dart:developer';

import 'package:chatbot_ai/core/constants/image_path_constants.dart';
import 'package:chatbot_ai/core/utils/model%20bottom%20sheet/bottom_sheet_ios_utils.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/custom_user_listtile_widget.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/loading_effect_listtile_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/widgets/drawer_listTile_loading-widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/widgets/drawer_list_tile_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/widgets/theme_container.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/search%20page/search_page.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/utils/delete_cancel_chat_room_sheet_utils.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CupertinoDrawer extends StatefulWidget {
  const CupertinoDrawer({
    super.key,
    required this.advancedDrawerController,
    required this.newChatNotifier,
    required this.idNotifier,
  });
  final ValueNotifier<bool> newChatNotifier;
  final AdvancedDrawerController advancedDrawerController;
  final ValueNotifier<int> idNotifier;
  @override
  State<CupertinoDrawer> createState() => _CupertinoDrawerState();
}

class _CupertinoDrawerState extends State<CupertinoDrawer> {
  TextEditingController chatRoomController = TextEditingController();

  @override
  void dispose() {
    chatRoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('DRAWER PAGE BUILD CALLED');

    return ThemeContainer(
      darkColor: CupertinoColors.darkBackgroundGray,
      lightColor: CupertinoColors.inactiveGray.withAlpha(25),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: _topTextfieldWidget(
                context,
                widget.newChatNotifier,
                widget.advancedDrawerController,
                widget.idNotifier,
              ),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: _topListTileWithLogo(
                context,
                widget.idNotifier,
                chatRoomController,
                widget.advancedDrawerController,
                widget.newChatNotifier,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsGeometry.only(
                  top: 20,
                  left: 10,
                  right: 10,
                ),
                child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
                  buildWhen: (previous, current) {
                    if (previous is InitialChatRoom &&
                        current is LoadingChatRoom) {
                      return true;
                    } else if (previous is LoadingChatRoom &&
                        current is LoadedChatRoom) {
                      return true;
                    } else if (previous is LoadedChatRoom &&
                        current is LoadedChatRoom) {
                      return previous.chatRoomEntities !=
                          current.chatRoomEntities;
                    } else if (current is ErrorChatRoom) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingChatRoom) {
                      return const DrawerListTileLoadingWidget();
                    } else if (state is LoadedChatRoom) {
                      var data = state.chatRoomEntities.reversed.toList();
                      return ValueListenableBuilder(
                        valueListenable: widget.idNotifier,
                        builder: (context, value, child) {
                          return ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return (data[index].title.isEmpty)
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsetsGeometry.symmetric(
                                        vertical: 5,
                                      ),
                                      child: GestureDetector(
                                        onLongPress: () {
                                          showDeleteSheetInChatRoom(
                                            context,
                                            isPin: data[index].isPin,
                                            onDelete: () async {
                                              context.read<ChatRoomBloc>().add(
                                                DeleteChatRoomEvent(
                                                  id: data[index].id,
                                                ),
                                              );
                                            },
                                            onPin: () {
                                              if (!data[index].isPin) {
                                                context
                                                    .read<ChatRoomBloc>()
                                                    .add(
                                                      PinOrUnpinChatRoomEvent(
                                                        chatRoomEntity:
                                                            data[index]
                                                                .copyWith(
                                                                  isPin: true,
                                                                ),
                                                      ),
                                                    );
                                              } else {
                                                context
                                                    .read<ChatRoomBloc>()
                                                    .add(
                                                      PinOrUnpinChatRoomEvent(
                                                        chatRoomEntity:
                                                            data[index]
                                                                .copyWith(
                                                                  isPin: false,
                                                                ),
                                                      ),
                                                    );
                                              }
                                            },
                                          );
                                        },
                                        child: DrawerListTileWidget(
                                          currentId: widget.idNotifier.value,
                                          chatRoomEntity: data[index],
                                          advancedDrawerController:
                                              widget.advancedDrawerController,
                                        ),
                                      ),
                                    );
                            },
                          );
                        },
                      );
                    } else if (state is ErrorChatRoom) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) {
                if (current is LoadingChat) {
                  return true;
                } else if (previous is LoadingChat && current is LoadedChat) {
                  return true;
                } else if (previous is LoadedChat && current is LoadedChat) {
                  return previous.userEntity != current.userEntity;
                }
                return false;
              },
              builder: (context, state) {
                if (state is LoadingChat) {
                  return const LoadingUserListtileEffectWidget();
                } else if (state is LoadedChat) {
                  var chatEntity = state.userEntity;
                  return CustomUserListtileWidget(
                    username: chatEntity.name,
                    imgPath: chatEntity.userImg,
                    onTap: () {
                      showCupertinoFullSheet(
                        context,
                        child: const SettingsPage(),
                        pageName: 'Settings',
                      );
                    },
                  );
                } else {
                  return const CustomUserListtileWidget(
                    username: 'No Username',
                    imgPath: '',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _topTextfieldWidget(
  BuildContext context,
  ValueNotifier<bool> newChatNotifier,
  AdvancedDrawerController advancedDrawerController,
  ValueNotifier<int> idNotifier,
) {
  return Hero(
    tag: 'move_to',
    child: CupertinoTextField(
      controller: TextEditingController(),
      readOnly: true,
      placeholder: 'Search',
      prefix: const Padding(
        padding: EdgeInsets.only(left: 5),
        child: Icon(CupertinoIcons.search),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          SearchPage.pageName,
          arguments:
              {'advanceDrawerController': advancedDrawerController}
                  as Map<String, dynamic>,
        );
      },
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CupertinoColors.systemGrey4, width: 0.8),
      ),
    ),
  );
}

Widget _topListTileWithLogo(
  BuildContext context,
  ValueNotifier<int> idNotifier,
  TextEditingController controller,
  AdvancedDrawerController advancedDrawerController,
  ValueNotifier<bool> newChatNotifier,
) {
  return ValueListenableBuilder(
    valueListenable: newChatNotifier,
    builder: (context, value, child) {
      return Container(
        decoration: BoxDecoration(
          color: value ? CupertinoColors.inactiveGray.withAlpha(50) : null,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: CupertinoListTile(
          onTap: () async {
            advancedDrawerController.hideDrawer();
            int id = DateTime.now().microsecondsSinceEpoch;

            context.read<ChatRoomBloc>().add(
              CreateChatRoomEvent(
                chatRoomEntity: ChatRoomEntity(
                  isTitleAssigned: false,
                  id: id,
                  title: controller.text.trim(),
                  createdAt: DateTime.now().toString(),
                  isPin: false,
                ),
              ),
            );
          },
          leading: Image.asset(ImagePathConstants.appLogo),
          title: const Text('Ai Chatbot'),
        ),
      );
    },
  );
}
