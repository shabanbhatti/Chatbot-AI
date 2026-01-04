import 'package:chatbot_ai/core/providers/providers.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/app_main_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/create_user_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/intro%20page/intro_page.dart';
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
