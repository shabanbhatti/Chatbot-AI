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
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/bottom_widgets.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/chat_box_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/model_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.advancedDrawerController});
  final AdvancedDrawerController advancedDrawerController;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatApiBloc chatApiBloc;
  TextEditingController chatController = TextEditingController();
  ValueNotifier<String> chatNotifier = ValueNotifier('');
  final ScrollController _scrollController = ScrollController();
  late AdvancedDrawerController advancedDrawerController;
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
            context.read<ChatBloc>().add(
              InsertEvent(chatEntity: state.chatEntity),
            );
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
            navigationBar: _appBar(
              advancedDrawerController: advancedDrawerController,
            ),
            child: Center(
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          _backgroundTheme(),
                          CupertinoScrollbar(
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
                                      return previous.chatsList.length !=
                                          current.chatsList.length;
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
                                      return _loadedChat(data, chatApiBloc);
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
                        ],
                      ),
                    ),
                    BlocSelector<ChatApiBloc, ChatApiState, String?>(
                      selector: (state) {
                        if (state is ErrorChatApi) {
                          return state.message;
                        } else {
                          return null;
                        }
                      },
                      bloc: chatApiBloc,
                      builder: (context, state) {
                        if (state != null) {
                          return CustomErrorBoxWidget(
                            exceptionMessage: state,
                            onRetry: () {
                              chatApiBloc.add(
                                OnSendPromptEvent(
                                  chatEntity: ChatEntity(
                                    message: chatController.text.trim(),
                                    createdAt: DateTime.now().toString(),
                                    role: ChatRoleConstants.user,
                                    imgPath: null,
                                    isFav: false,
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),

                    BlocSelector<VoiceBloc, VoiceState, String>(
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
                    Padding(
                      padding: const EdgeInsetsGeometry.only(bottom: 10),
                      child: BottomWidgets(
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
                            context.read<VoiceBloc>().add(StopRecordingEvent());
                          }
                        },
                        onSend: () {
                          context.read<ChatBloc>().add(
                            InsertEvent(
                              chatEntity: ChatEntity(
                                message: chatController.text.trim(),
                                createdAt: DateTime.now().toString(),
                                role: ChatRoleConstants.user,
                                imgPath: null,
                                isFav: false,
                              ),
                            ),
                          );
                          chatApiBloc.add(
                            OnSendPromptEvent(
                              chatEntity: ChatEntity(
                                message: chatController.text.trim(),
                                createdAt: DateTime.now().toString(),
                                role: ChatRoleConstants.user,
                                imgPath: null,
                                isFav: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ObstructingPreferredSizeWidget _appBar({
  required AdvancedDrawerController advancedDrawerController,
}) {
  return CupertinoNavigationBar(
    leading: GestureDetector(
      onTap: () {
        advancedDrawerController.showDrawer();
      },
      child: const Icon(CupertinoIcons.line_horizontal_3_decrease, size: 25),
    ),
    middle: const Text(
      'Ai Chatbot',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
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

Widget _loadedChat(List<ChatEntity> data, ChatApiBloc chatApiBloc) {
  return SliverPadding(
    padding: const EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 5),
    sliver: BlocBuilder<ChatApiBloc, ChatApiState>(
      buildWhen: (previous, current) {
        if (current is LoadingChatApi) {
          return true;
        } else if (current is LoadedChatApi) {
          return true;
        } else if (current is ErrorChatApi) {
          return false;
        }
        return false;
      },
      bloc: chatApiBloc,
      builder: (context, chatState) {
        return SliverList.builder(
          itemCount: data.length + (chatState is LoadingChatApi ? 1 : 0),

          itemBuilder: (context, index) {
            if (chatState is LoadingChatApi && index == data.length) {
              return const ModelLoadingWidget();
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
  return ChatBoxWidget(
    isUser: isUser,
    message: chats.message,
    isFav: chats.isFav,
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
