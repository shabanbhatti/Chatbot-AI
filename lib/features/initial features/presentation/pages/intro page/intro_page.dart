import 'dart:developer';

import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/constants/image_path_constants.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/widgets/shimmer%20effects%20widgets/text_shimmer_effect.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/app_main_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/create_user_page.dart';
import 'package:flutter/cupertino.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});
  static const String pageName = '/';

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    isNewUser();
  }

  void isNewUser() async {
    var isNewUserHere = await getIt<SharedPreferencesService>().getBool(
      SharedPreferencesKEYS.loggedKey,
    );

    if (isNewUserHere) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppMainPage.pageName, (route) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(CreateUserPage.pageName, (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log('INTRO PAGE BUILD CALLED');
    return CupertinoPageScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Hero(
                tag: 'move',
                child: Image.asset(
                  ImagePathConstants.appLogo,
                  height: 150,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 30),
              const TextShimmerEffect(text: 'Ai Chatbot'),
            ],
          ),
        ),
      ),
    );
  }
}
