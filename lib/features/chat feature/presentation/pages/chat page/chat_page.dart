import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/local_chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/local_chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/local%20chat%20bloc/local_chat_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/bottom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.advancedDrawerController});
  final AdvancedDrawerController advancedDrawerController;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  ValueNotifier<String> chatNotifier = ValueNotifier('');
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    chatController.dispose();
    chatNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
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
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 10,
                              ),
                              sliver: SliverList.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final chats = data[index];
                                  final isUser =
                                      chats.role == ChatRoleConstants.user;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: isUser ? 30 : 0,
                                      // right: isUser ? 8 : 30,
                                      top: 6,
                                      bottom: 6,
                                    ),
                                    child: Align(
                                      alignment: isUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isUser
                                              ? CupertinoColors.inactiveGray
                                                    .withAlpha(100)
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: GptMarkdown(
                                          chats.message,
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
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
                // BlocBuilder<ChatBloc, ChatState>(
                //   builder: (context, state) {
                //     if (state is LoadingOnSendingChat) {
                //       return CupertinoActivityIndicator();
                //     } else {
                //       return SizedBox();
                //     }
                //   },
                // ),
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
                    context.read<ChatBloc>().add(
                      SendPromptEvent(
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
    );
  }
}
