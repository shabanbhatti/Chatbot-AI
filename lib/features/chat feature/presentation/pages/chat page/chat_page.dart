import 'dart:developer';

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

  @override
  void initState() {
    super.initState();

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
    return BlocListener<VoiceBloc, VoiceState>(
      listener: (context, state) {
        if (state.isLoaded) {
          print(state.reply);
          chatController.text = state.reply;
          chatNotifier.value = state.reply;
        }
        if (state.isError) {
          ShowToast.basicToast(
            message: state.error,
            color: CupertinoColors.destructiveRed,
            duration: 3,
          );
        }
      },
      child: BlocListener<ChatApiBloc, ChatApiState>(
        bloc: chatApiBloc,
        listener: (context, state) {
          if (state is LoadedChatApi) {
            log(state.chatEntity.isFav.toString());
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
            navigationBar: CupertinoNavigationBar(
              leading: GestureDetector(
                onTap: () {
                  widget.advancedDrawerController.showDrawer();
                },
                child: const Icon(
                  CupertinoIcons.line_horizontal_3_decrease,
                  size: 25,
                ),
              ),
              middle: const Text(
                'Ai Chatbot',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            child: Center(
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            BlocBuilder<ChatBloc, ChatState>(
                              builder: (context, state) {
                                log('CHAT PAGE BLOC CALLED');
                                if (state is LoadingChat) {
                                  return const SliverFillRemaining(
                                    child: Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                  );
                                } else if (state is LoadedChat) {
                                  var data = state.chatsList;
                                  return SliverPadding(
                                    padding: const EdgeInsetsGeometry.symmetric(
                                      horizontal: 10,
                                    ),
                                    sliver: BlocBuilder<ChatApiBloc, ChatApiState>(
                                      bloc: chatApiBloc,
                                      builder: (context, chatState) {
                                        return SliverList.builder(
                                          itemCount:
                                              data.length +
                                              (chatState is LoadingChatApi
                                                  ? 1
                                                  : 0),
                                          itemBuilder: (context, index) {
                                            if (chatState is LoadingChatApi &&
                                                index == data.length) {
                                              return const ModelLoadingWidget();
                                            } else {
                                              final chats = data[index];
                                              final isUser =
                                                  chats.role ==
                                                  ChatRoleConstants.user;

                                              return ChatBoxWidget(
                                                isUser: isUser,
                                                message: chats.message,
                                                isFav: chats.isFav,
                                                onFavTap: () {
                                                  print(chats.isFav);
                                                  if (chats.isFav) {
                                                    context
                                                        .read<ChatBloc>()
                                                        .add(
                                                          UpdateChatEvent(
                                                            chatEntity: chats
                                                                .copyWith(
                                                                  isFav: false,
                                                                ),
                                                          ),
                                                        );
                                                  } else {
                                                    context
                                                        .read<ChatBloc>()
                                                        .add(
                                                          UpdateChatEvent(
                                                            chatEntity: chats
                                                                .copyWith(
                                                                  isFav: true,
                                                                ),
                                                          ),
                                                        );
                                                    ShowToast.basicToast(
                                                      message:
                                                          '🎉 Thanks for your feedback!',
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                } else if (state is ErrorChat) {
                                  return SliverFillRemaining(
                                    child: Center(child: Text(state.message)),
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
                    BlocBuilder<ChatApiBloc, ChatApiState>(
                      bloc: chatApiBloc,
                      builder: (context, state) {
                        if (state is ErrorChatApi) {
                          return CustomErrorBoxWidget(
                            exceptionMessage: state.message,
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

                    BlocBuilder<VoiceBloc, VoiceState>(
                      builder: (context, state) {
                        if (state.isError) {
                          return CustomErrorBoxWidget(
                            exceptionMessage: state.error,
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
                      padding: EdgeInsetsGeometry.only(bottom: 10),
                      child: BottomWidgets(
                        chatNotifier: chatNotifier,
                        chatController: chatController,
                        onMic: () {
                          if (!context.read<VoiceBloc>().state.isSpeaking) {
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
