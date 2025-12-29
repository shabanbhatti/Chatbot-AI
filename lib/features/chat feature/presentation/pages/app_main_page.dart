import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/chat_page.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/cupertino_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

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
      drawer: const CupertinoDrawer(),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: CupertinoColors.white),
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
