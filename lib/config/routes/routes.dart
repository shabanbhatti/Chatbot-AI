import 'package:chatbot_ai/core/providers/providers.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/app_main_page.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/search%20page/search_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/create_user_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/intro%20page/intro_page.dart';
import 'package:cupertino_sidemenu/cupertino_sidemenu.dart';
import 'package:flutter/cupertino.dart';

Route<dynamic> onGenerateRoute(RouteSettings rs) {
  switch (rs.name) {
    case IntroPage.pageName:
      return CupertinoPageRoute(
        builder: (context) => const IntroPage(),
        settings: rs,
      );

    case CreateUserPage.pageName:
      return CupertinoPageRoute(
        builder: (context) => const CreateUserPage(),
        settings: rs,
      );

    case SearchPage.pageName:
      return PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation.drive(Tween(begin: 1, end: 1)),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          Map<String, dynamic> data = rs.arguments as Map<String, dynamic>;

          CupertinoSidemenuController advancedDrawerController =
              data['advanceDrawerController'] as CupertinoSidemenuController;

          return SearchPage(advancedDrawerController: advancedDrawerController);
        },

        settings: rs,
      );
    case AppMainPage.pageName:
      return CupertinoPageRoute(
        builder: (context) =>
            Providers.appMainPageProviders(const AppMainPage()),
        settings: rs,
      );

    default:
      return CupertinoPageRoute(
        builder: (context) => const CupertinoPageScaffold(child: SizedBox()),
      );
  }
}
