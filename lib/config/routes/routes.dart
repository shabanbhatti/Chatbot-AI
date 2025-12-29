import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/voice_to_text_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/app_main_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_event.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/create_user_page.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/intro%20page/intro_page.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

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

    case SettingsPage.pageName:
      return CupertinoPageRoute(
        builder: (context) => const SettingsPage(),
        settings: rs,
      );

    case AppMainPage.pageName:
      return CupertinoPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserBloc(
                getUserUsecase: getIt<GetUserUsecase>(),
                insertUserUsecase: getIt<InsertUserUsecase>(),
                deleteUserUsecase: getIt<DeleteUserUsecase>(),
              )..add(GetUserEvent()),
            ),
            BlocProvider(
              create: (context) => VoiceBloc(
                audioRecorder: AudioRecorder(),
                voiceToTextUsecase: getIt<VoiceToTextUsecase>(),
              ),
            ),

            BlocProvider(
              create: (context) =>
                  ChatBloc(
                      getChatsUsecase: getIt<GetChatsUsecase>(),
                      insertChatUsecase: getIt<InsertChatUsecase>(),
                      sendPromptUsecase: getIt<SendPromptUsecase>(),
                      updateChatUsecase: getIt<UpdateChatUsecase>(),
                      getUserUsecase: getIt<GetUserUsecase>(),
                    )
                    ..add(GetChatsEvent())
                    ..add(GetUserInDrawerEvent()),
            ),
          ],
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
