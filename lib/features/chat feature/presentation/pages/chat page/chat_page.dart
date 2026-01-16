import 'dart:developer';
import 'dart:io';

import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/core/widgets/custom_error_box_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/bottom_widgets.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/chat_box_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/model_loading_widget.dart';
import 'package:cupertino_sidemenu/cupertino_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.advancedDrawerController,
    required this.newChatNotifier,
    required this.idNotifier,
  });
  final CupertinoSidemenuController advancedDrawerController;
  final ValueNotifier<bool> newChatNotifier;
  final ValueNotifier<int> idNotifier;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatApiBloc chatApiBloc;
  TextEditingController chatController = TextEditingController();
  ValueNotifier<String> chatNotifier = ValueNotifier('');
  ValueNotifier<List<String>> multiImagesNotifier = ValueNotifier([]);
  final ScrollController _scrollController = ScrollController();
  late CupertinoSidemenuController advancedDrawerController;
  @override
  void initState() {
    super.initState();

    advancedDrawerController = widget.advancedDrawerController;
    chatApiBloc = ChatApiBloc(sendPromptUsecase: getIt<SendPromptUsecase>());
  }

  @override
  void dispose() {
    chatApiBloc.close();
    _scrollController.dispose();
    chatController.dispose();
    chatNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Chat page build called');
    return BlocListener<VoiceBloc, VoiceState>(
      listener: (context, state) {
        if (state is IsLoadedVoice) {
          chatController.text = state.reply;
          chatNotifier.value = state.reply;
        }
        if (state is IsErrorVoice) {
          ShowToast.basicToast(
            message: state.message,
            color: CupertinoColors.destructiveRed,
            duration: 3,
          );
        }
      },
      child: BlocListener<ChatApiBloc, ChatApiState>(
        bloc: chatApiBloc,
        listener: (context, state) {
          if (state is LoadedChatApi) {
            if (state.chatEntity != null) {
              context.read<ChatBloc>().add(
                InsertEvent(chatEntity: state.chatEntity!),
              );
            }
          }

          if (state is ErrorChatApi) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            });
            ShowToast.basicToast(
              message: state.message,
              color: CupertinoColors.destructiveRed,
            );
          }
        },
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is LoadedChat) {
              chatController.clear();
              chatNotifier.value = '';
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController.jumpTo(
                  _scrollController.position.maxScrollExtent,
                );
              });
            }
            if (state is LoadedInsertedChat) {
              context.read<ChatBloc>().add(GetChatsEvent());
            }

            if (state is ErrorChat) {
              ShowToast.basicToast(
                message: state.message,
                color: CupertinoColors.destructiveRed,
              );
            }
          },
          child: CupertinoPageScaffold(
            // navigationBar: _appBar(
            //   advancedDrawerController: advancedDrawerController,
            // ),
            child: Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: _backgroundTheme(),
                  ),
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: SafeArea(
                      child: Column(
                        children: [
                          CupertinoListTile(
                            leading: GestureDetector(
                              onTap: () {
                                advancedDrawerController.openLeftMenu();
                              },
                              child: const Icon(
                                CupertinoIcons.line_horizontal_3_decrease,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              'Ai Chatbot',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoScrollbar(
                              controller: _scrollController,
                              child: CustomScrollView(
                                controller: _scrollController,
                                slivers: [
                                  BlocBuilder<ChatBloc, ChatState>(
                                    buildWhen: (previous, current) {
                                      if (current is LoadingChat) {
                                        return true;
                                      } else if (previous is LoadingChat &&
                                          current is LoadedChat) {
                                        return true;
                                      } else if (previous is LoadedChat &&
                                          current is LoadedChat) {
                                        return previous.chatsList !=
                                            current.chatsList;
                                      } else {
                                        return false;
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is LoadingChat) {
                                        return const SliverFillRemaining(
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        );
                                      } else if (state is LoadedChat) {
                                        var data = state.chatsList;
                                        return SliverPadding(
                                          padding: EdgeInsetsGeometry.only(
                                            bottom: 60,
                                          ),
                                          sliver: _loadedChat(
                                            data,
                                            chatApiBloc,
                                            chatController,
                                            multiImagesNotifier,
                                          ),
                                        );
                                      } else if (state is ErrorChat) {
                                        return SliverFillRemaining(
                                          child: Center(
                                            child: Text(state.message),
                                          ),
                                        );
                                      } else {
                                        return const SliverToBoxAdapter();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BlocSelector<VoiceBloc, VoiceState, String>(
                      selector: (state) {
                        if (state is IsErrorVoice) {
                          return state.message;
                        } else {
                          return '';
                        }
                      },
                      builder: (context, state) {
                        if (state.isNotEmpty) {
                          return CustomErrorBoxWidget(
                            exceptionMessage: state,
                            onClose: () {},
                            onRetry: () {
                              context.read<VoiceBloc>().add(
                                StartRecordingEvent(),
                              );
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          vertical: (Platform.isAndroid) ? 15 : 0,
                        ),
                        child: BottomWidgets(
                          multiImagesNotifier: multiImagesNotifier,
                          chatApiBloc: chatApiBloc,
                          chatNotifier: chatNotifier,
                          chatController: chatController,

                          onMic: () {
                            var loading =
                                context.read<VoiceBloc>().state
                                    is IsSpeakingVoice;
                            log(loading.toString());
                            if (!loading) {
                              context.read<VoiceBloc>().add(
                                StartRecordingEvent(),
                              );
                            } else {
                              context.read<VoiceBloc>().add(
                                StopRecordingEvent(),
                              );
                            }
                          },
                          onSend: () async {
                            widget.newChatNotifier.value = false;
                            var id = context.read<ChatRoomIdPrefBloc>().state;
                            widget.idNotifier.value = id;
                            context.read<ChatBloc>().add(
                              InsertEvent(
                                chatEntity: ChatEntity(
                                  chatRoomId: id,
                                  id: DateTime.now().microsecondsSinceEpoch,
                                  message: chatController.text.trim(),
                                  createdAt: DateTime.now().toString(),
                                  role: ChatRoleConstants.user,
                                  imgPaths: multiImagesNotifier.value,
                                  isFav: false,
                                ),
                              ),
                            );

                            chatApiBloc.add(
                              OnSendPromptEvent(
                                chatEntity: ChatEntity(
                                  chatRoomId: id,
                                  id: null,
                                  message: chatController.text.trim(),
                                  createdAt: DateTime.now().toString(),
                                  role: ChatRoleConstants.user,
                                  imgPaths: multiImagesNotifier.value,
                                  isFav: false,
                                ),
                              ),
                            );

                            var loaded =
                                context.read<ChatRoomBloc>().state
                                    as LoadedChatRoom;
                            var chatRoomEntity = loaded.chatRoomEntities
                                .where((element) => element.id == id)
                                .toList();
                            if (!chatRoomEntity[0].isTitleAssigned) {
                              context.read<ChatRoomBloc>().add(
                                UpdateChatRoomEvent(
                                  chatRoomEntity: chatRoomEntity[0].copyWith(
                                    title: chatController.text.trim(),
                                    isTitleAssigned: true,
                                  ),
                                ),
                              );
                            }
                            multiImagesNotifier.value = [];
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _backgroundTheme() {
  return BlocBuilder<ChatBloc, ChatState>(
    buildWhen: (previous, current) {
      if (previous is LoadingChat && current is LoadedChat) {
        return true;
      } else if (previous is LoadedChat && current is LoadedChat) {
        return previous.chatBckgndImgPathsEntity !=
            current.chatBckgndImgPathsEntity;
      } else {
        return false;
      }
    },
    builder: (context, state) {
      if (state is LoadedChat) {
        var chatBackgroundPath = state.chatBckgndImgPathsEntity;
        if (chatBackgroundPath != null) {
          return Opacity(
            opacity: 0.7,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: (chatBackgroundPath.imgPaths.startsWith('assets/'))
                  ? Image.asset(chatBackgroundPath.imgPaths, fit: BoxFit.cover)
                  : Image.file(
                      File(chatBackgroundPath.imgPaths),
                      fit: BoxFit.cover,
                    ),
            ),
          );
        } else {
          return const SizedBox();
        }
      } else {
        return const SizedBox(height: double.infinity, width: double.infinity);
      }
    },
  );
}

Widget _loadedChat(
  List<ChatEntity> data,
  ChatApiBloc chatApiBloc,
  TextEditingController controller,
  ValueNotifier<List<String>> multiImgsPath,
) {
  return SliverPadding(
    padding: const EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 5),
    sliver: BlocBuilder<ChatApiBloc, ChatApiState>(
      buildWhen: (previous, current) {
        print(
          'PREVIOUS: ${previous.runtimeType} | CURRENT: ${current.runtimeType}',
        );
        if (current is LoadingChatApi) {
          return true;
        } else if (previous is LoadingChatApi && current is LoadedChatApi) {
          return true;
        } else if (previous is LoadedChatApi && current is LoadedChatApi) {
          return previous.chatEntity != current.chatEntity;
        } else if (previous is ErrorChatApi && current is LoadedChatApi) {
          return true;
        } else if (current is ErrorChatApi) {
          return true;
        } else {
          return false;
        }
      },
      bloc: chatApiBloc,
      builder: (context, chatState) {
        return SliverList.builder(
          itemCount:
              data.length +
              (chatState is LoadingChatApi || chatState is ErrorChatApi
                  ? 1
                  : 0),

          itemBuilder: (context, index) {
            if (chatState is LoadingChatApi && index == data.length) {
              return const ModelLoadingWidget();
            } else if (chatState is ErrorChatApi && index == data.length) {
              return CustomErrorBoxWidget(
                onClose: () {
                  chatApiBloc.add(OnCloseErrorApiEvent());
                },
                exceptionMessage: chatState.message,
                onRetry: () {
                  chatApiBloc.add(
                    OnSendPromptEvent(
                      chatEntity: ChatEntity(
                        id: null,
                        chatRoomId:
                            (context.read<ChatRoomBloc>().state
                                    as LoadedChatRoom)
                                .chatRoomEntities[0]
                                .id,
                        message: controller.text.trim(),
                        createdAt: DateTime.now().toString(),
                        role: ChatRoleConstants.user,
                        imgPaths: multiImgsPath.value,
                        isFav: false,
                      ),
                    ),
                  );
                },
              );
            } else {
              final chats = data[index];
              final isUser = chats.role == ChatRoleConstants.user;

              return _chatBox(context, isUser: isUser, chats: chats);
            }
          },
        );
      },
    ),
  );
}

Widget _chatBox(
  BuildContext context, {
  required bool isUser,
  required ChatEntity chats,
}) {
  log('----in Chat page: ID: ${chats.id}');
  return ChatBoxWidget(
    isUser: isUser,
    message: chats.message,
    isFav: chats.isFav,
    chatEntity: chats,
    onFavTap: () {
      if (chats.isFav) {
        context.read<ChatBloc>().add(
          UpdateChatEvent(chatEntity: chats.copyWith(isFav: false)),
        );
      } else {
        context.read<ChatBloc>().add(
          UpdateChatEvent(chatEntity: chats.copyWith(isFav: true)),
        );
        ShowToast.basicToast(message: '🎉 Thanks for your feedback!');
      }
    },
  );
}
