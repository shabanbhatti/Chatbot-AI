import 'dart:developer';

import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_event.dart';
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
  }

  @override
  void dispose() {
    advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('App main page build called');
    return AdvancedDrawer(
      initialDrawerScale: 5,
      openRatio: 0.7,
      drawer: const CupertinoDrawer(),

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

      child: ChatPage(advancedDrawerController: advancedDrawerController),
    );
  }
}
