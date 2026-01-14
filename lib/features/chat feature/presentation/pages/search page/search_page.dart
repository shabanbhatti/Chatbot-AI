import 'dart:developer';

import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/delete_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chat_rooms_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/widgets/drawer_listTile_loading-widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/widgets/circle_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.advancedDrawerController});
  static const String pageName = '/search_page';

  final AdvancedDrawerController advancedDrawerController;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  late ChatRoomBloc chatRoomBloc;
  @override
  void initState() {
    super.initState();
    chatRoomBloc = ChatRoomBloc(
      getChatRoomsUsecase: getIt<GetChatRoomsUsecase>(),
      insertChatRoomUsecase: getIt<InsertChatRoomUsecase>(),
      updateChatRoomUsecase: getIt<UpdateChatRoomUsecase>(),
      deleteChatRoomUsecase: getIt<DeleteChatRoomUsecase>(),
    );
    chatRoomBloc.add(GetChatRoomsEvent());
  }

  @override
  void dispose() {
    chatRoomBloc.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Search page build called');
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatRoomBloc, ChatRoomState>(
          bloc: chatRoomBloc,
          listener: (context, state) {
            if (state is CreatedFirstTimeChatRoom) {
              context.read<ChatRoomIdPrefBloc>().add(
                SetChatRoomIdPrefEvent(value: state.id),
              );
              context.read<NewChatPrefBloc>().add(
                SetNewChatboolPrefEvent(value: true),
              );
              chatRoomBloc.add(GetChatRoomsEvent());
              context.read<ChatBloc>().add(GetChatsEvent());
            }
            if (state is DeletedChatRoom) {
              chatRoomBloc.add(
                CreateChatRoomEvent(
                  chatRoomEntity: ChatRoomEntity(
                    isTitleAssigned: false,
                    id: DateTime.now().microsecondsSinceEpoch,
                    createdAt: DateTime.now().toString(),
                    title: "",
                    isPin: false,
                  ),
                ),
              );
            }

            if (state is CreatedChatRoom) {
              context.read<NewChatPrefBloc>().add(
                SetNewChatboolPrefEvent(value: true),
              );
              context.read<ChatRoomIdPrefBloc>().add(
                SetChatRoomIdPrefEvent(value: state.id),
              );

              context.read<ChatBloc>().add(GetChatsEvent());
              chatRoomBloc.add(GetChatRoomsEvent());
            }
          },
        ),
      ],
      child: CupertinoPageScaffold(
        child: Center(
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                _topWidget(context, searchController, chatRoomBloc),
                SliverPadding(
                  padding: EdgeInsetsGeometry.only(top: 20),
                  sliver: BlocBuilder<ChatRoomBloc, ChatRoomState>(
                    bloc: chatRoomBloc,
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
                        return const SliverToBoxAdapter(
                          child: DrawerListTileLoadingWidget(),
                        );
                      } else if (state is LoadedChatRoom) {
                        var list = state.chatRoomEntities.reversed.toList();
                        return SliverList.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var data = list[index];
                            return (list[index].title.isEmpty)
                                ? const SizedBox()
                                : CupertinoListTile(
                                    onTap: () async {
                                      widget.advancedDrawerController
                                          .hideDrawer();
                                      Navigator.pop(context);
                                      context.read<ChatRoomIdPrefBloc>().add(
                                        SetChatRoomIdPrefEvent(value: data.id),
                                      );
                                      context.read<NewChatPrefBloc>().add(
                                        SetNewChatboolPrefEvent(value: false),
                                      );

                                      context.read<ChatBloc>().add(
                                        GetChatsEvent(),
                                      );
                                    },
                                    title: Text(data.title),
                                  );
                          },
                        );
                      } else if (state is ErrorChatRoom) {
                        return SliverFillRemaining(
                          child: Center(child: Text(state.message)),
                        );
                      } else {
                        return const SliverToBoxAdapter(child: SizedBox());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _topWidget(
  BuildContext context,
  TextEditingController searchController,
  ChatRoomBloc chatRoomBloc,
) {
  return SliverPadding(
    padding: const EdgeInsetsGeometry.symmetric(horizontal: 7, vertical: 20),
    sliver: SliverToBoxAdapter(
      child: Hero(
        tag: 'move_to',
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: CupertinoTextField(
                controller: searchController,
                autofocus: true,
                placeholder: 'Search',
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Icon(CupertinoIcons.search),
                ),
                onChanged: (value) {
                  chatRoomBloc.add(SearchOnChangedEvent(query: value));
                },
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: CupertinoColors.systemGrey4,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 1),
                child: CircleBtnWidget(
                  radius: 35,
                  icon: CupertinoIcons.xmark,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
