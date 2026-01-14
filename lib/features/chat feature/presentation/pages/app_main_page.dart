import 'dart:developer';

import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_event.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/chat_page.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/cupertino_drawer.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/widgets/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});
  static const String pageName = '/app_main_page';

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  late AdvancedDrawerController advancedDrawerController;
  @override
  void initState() {
    super.initState();
    advancedDrawerController = AdvancedDrawerController();
    context.read<AccentColorBloc>().add(GetColorEvent());
    context.read<ChatRoomBloc>().add(
      CreateFirstChatRoomEvent(
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

  ValueNotifier<bool> newChatNotifier = ValueNotifier(false);
  ValueNotifier<int> idNotifier = ValueNotifier(0);

  @override
  void dispose() {
    advancedDrawerController.dispose();
    newChatNotifier.dispose();
    idNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('App main page build called');
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatRoomBloc, ChatRoomState>(
          listener: (context, state) {
            if (state is CreatedFirstTimeChatRoom) {
              context.read<ChatRoomIdPrefBloc>().add(
                SetChatRoomIdPrefEvent(value: state.id),
              );
              context.read<NewChatPrefBloc>().add(
                SetNewChatboolPrefEvent(value: true),
              );
              context.read<ChatRoomBloc>().add(GetChatRoomsEvent());
              context.read<ChatBloc>().add(GetChatsEvent());
            }
            if (state is DeletedChatRoom) {
              context.read<ChatRoomBloc>().add(
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
              context.read<ChatRoomBloc>().add(GetChatRoomsEvent());
              print('=========');
            }
          },
        ),
        BlocListener<NewChatPrefBloc, bool>(
          listener: (context, state) {
            log('NEW CHAT LISNER CALLED');
            newChatNotifier.value = state;
          },
        ),

        BlocListener<ChatRoomIdPrefBloc, int>(
          listener: (context, state) {
            log('CHAT ID LISNER CALLED');
            idNotifier.value = state;
          },
        ),
      ],
      child: AdvancedDrawer(
        initialDrawerScale: 5,
        openRatio: 0.7,
        drawer: CupertinoDrawer(
          idNotifier: idNotifier,
          advancedDrawerController: advancedDrawerController,
          newChatNotifier: newChatNotifier,
        ),

        backdrop: ThemeContainer(
          lightColor: CupertinoColors.white,
          darkColor: CupertinoColors.black,
        ),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),

        child: ChatPage(
          advancedDrawerController: advancedDrawerController,
          newChatNotifier: newChatNotifier,
          idNotifier: idNotifier,
        ),
      ),
    );
  }
}
