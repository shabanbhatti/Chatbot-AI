import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/app_main_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_event.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/create_user_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/intro%20page/intro_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        builder: (context) => BlocProvider(
          create: (context) => UserBloc(
            getUserUsecase: getIt<GetUserUsecase>(),
            insertUserUsecase: getIt<InsertUserUsecase>(),
            deleteUserUsecase: getIt<DeleteUserUsecase>(),
          )..add(GetUserEvent()),
          child: const AppMainPage(),
        ),
        settings: rs,
      );

    default:
      return CupertinoPageRoute(
        builder: (context) => const CupertinoPageScaffold(child: SizedBox()),
      );
  }
}
