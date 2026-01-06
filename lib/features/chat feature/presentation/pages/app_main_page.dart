import 'dart:developer';

import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_event.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/chat_page.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/cupertino_drawer.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/get_chat_imgs_paths_usecase.dart';
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
    log('MAIN PAGE INIT CALLED');
    context.read<AccentColorBloc>().add(GetColorEvent());
  }

  @override
  void dispose() {
    advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      initialDrawerScale: 5,
      openRatio: 0.7,
      drawer: BlocProvider(
        create: (context) => ChatBloc(
          getChatsUsecase: getIt<GetChatsUsecase>(),
          insertChatUsecase: getIt<InsertChatUsecase>(),
          sendPromptUsecase: getIt<SendPromptUsecase>(),
          updateChatUsecase: getIt<UpdateChatUsecase>(),
          getUserUsecase: getIt<GetUserUsecase>(),
          getChatImgsPathsUsecase: getIt<GetChatImgsPathsUsecase>(),
        )..add(GetChatsEvent()),
        child: const CupertinoDrawer(),
      ),

      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        ),
      ),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),

      child: ChatPage(advancedDrawerController: advancedDrawerController),
    );
  }
}
