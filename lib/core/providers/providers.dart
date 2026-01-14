import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_event.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_bloc.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_event.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_chat_bckgnd_img_paths_usecae.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/update_user_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/delete_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chat_rooms_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/voice_to_text_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_event.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/delete_chat_img_paths_usecase.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/get_chat_imgs_paths_usecase.dart';
import 'package:chatbot_ai/features/settings%20feature/domain/usecases/update_chat_img_path_usecase.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_bloc.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_event.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

abstract class Providers {
  static MultiBlocProvider appMainPageProviders(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(
            getUserUsecase: getIt<GetUserUsecase>(),
            insertUserUsecase: getIt<InsertUserUsecase>(),
            deleteUserUsecase: getIt<DeleteUserUsecase>(),
            insertChatBckgndImgPathsUsecae:
                getIt<InsertChatBckgndImgPathsUsecae>(),
          )..add(GetUserEvent()),
        ),
        BlocProvider(
          create: (context) => VoiceBloc(
            audioRecorder: AudioRecorder(),
            voiceToTextUsecase: getIt<VoiceToTextUsecase>(),
          ),
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider mainFileGlobalProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(
            getChatsUsecase: getIt<GetChatsUsecase>(),
            insertChatUsecase: getIt<InsertChatUsecase>(),
            sendPromptUsecase: getIt<SendPromptUsecase>(),
            updateChatUsecase: getIt<UpdateChatUsecase>(),
            getUserUsecase: getIt<GetUserUsecase>(),
            getChatImgsPathsUsecase: getIt<GetChatImgsPathsUsecase>(),
          ),
        ),
        BlocProvider(
          create: (context) => ChatRoomBloc(
            getChatRoomsUsecase: getIt<GetChatRoomsUsecase>(),
            insertChatRoomUsecase: getIt<InsertChatRoomUsecase>(),
            updateChatRoomUsecase: getIt<UpdateChatRoomUsecase>(),
            deleteChatRoomUsecase: getIt<DeleteChatRoomUsecase>(),
          ),
        ),

        BlocProvider(
          create: (context) => NewChatPrefBloc(
            sharedPreferencesService: getIt<SharedPreferencesService>(),
          ),
        ),

        BlocProvider(
          create: (context) => ChatRoomIdPrefBloc(
            sharedPreferencesService: getIt<SharedPreferencesService>(),
          ),
        ),
        // BlocProvider(create: (context) => ImagePickerBloc(imagePickerUtils: getIt<ImagePickerUtils>()),),
        BlocProvider(
          create: (context) {
            return SettingBloc(
              getUserUsecase: getIt<GetUserUsecase>(),
              updateChatUsecase: getIt<UpdateUserUsecase>(),
              deleteChatImgPathsUsecase: getIt<DeleteChatImgPathsUsecase>(),
              getChatImgsPathsUsecase: getIt<GetChatImgsPathsUsecase>(),
              insertChatImgPathUsecase: getIt<InsertChatBckgndImgPathsUsecae>(),
              updateChatImgPathUsecase: getIt<UpdateChatImgPathUsecase>(),
            )..add(GetDataInSettingsEvent());
          },
          child: SettingsPage(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            sharedPreferencesService: getIt<SharedPreferencesService>(),
          )..add(GetTheme()),
        ),
        BlocProvider<AccentColorBloc>(
          create: (context) => AccentColorBloc(
            sharedPreferencesService: getIt<SharedPreferencesService>(),
          )..add(GetColorEvent()),
        ),
      ],
      child: child,
    );
  }
}
