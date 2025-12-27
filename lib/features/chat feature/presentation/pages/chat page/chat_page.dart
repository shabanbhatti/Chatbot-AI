import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/core/widgets/custom_error_box_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20api%20bloc/chat_api_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/chat_state.dart';
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
    return BlocListener<ChatApiBloc, ChatApiState>(
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
        },
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                widget.advancedDrawerController.showDrawer();
              },
              child: const Icon(CupertinoIcons.slider_horizontal_3, size: 25),
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
                                  sliver: SliverList.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final chats = data[index];
                                      final isUser =
                                          chats.role == ChatRoleConstants.user;

                                      return ChatBoxWidget(
                                        isUser: isUser,
                                        message: chats.message,
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
                      if (state is LoadingChatApi) {
                        return const ModelLoadingWidget();
                      } else if (state is ErrorChatApi) {
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
                  BottomWidgets(
                    chatNotifier: chatNotifier,
                    chatController: chatController,
                    onMic: () {},
                    onSend: () {
                      context.read<ChatBloc>().add(
                        InsertEvent(
                          chatEntity: ChatEntity(
                            message: chatController.text.trim(),
                            createdAt: DateTime.now().toString(),
                            role: ChatRoleConstants.user,
                            imgPath: null,
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
                          ),
                        ),
                      );
                    },
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
