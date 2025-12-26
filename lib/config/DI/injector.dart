import 'package:chatbot_ai/core/database/app_database.dart';
import 'package:chatbot_ai/core/dio%20client/dio_client.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:chatbot_ai/core/utils/image_picker_utils.dart';
import 'package:chatbot_ai/features/chat%20feature/data/datasource/local%20datasource/chat_local_datasource.dart';
import 'package:chatbot_ai/features/chat%20feature/data/datasource/remote%20datasource/chat_remote_datasource.dart';
import 'package:chatbot_ai/features/chat%20feature/data/repository%20impl/chat_repository_impl.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/repository/chat_repository.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chats_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/send_prompt_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/data/datasource/local%20datasource/user_local_datasource.dart';
import 'package:chatbot_ai/features/initial%20features/data/datasource/remote%20datasource/countries_remote_datasource.dart';
import 'package:chatbot_ai/features/initial%20features/data/repository%20impl/countries_repository_impl.dart';
import 'package:chatbot_ai/features/initial%20features/data/repository%20impl/user_repository_impl.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/countries_repository.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/user_repository.dart';
import 'package:chatbot_ai/features/initial%20features/domain/usecases/delete_user_usecase_impl.dart';
import 'package:chatbot_ai/features/initial%20features/domain/usecases/get_countries_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/domain/usecases/get_user_usecase_impl.dart';
import 'package:chatbot_ai/features/initial%20features/domain/usecases/insert_user_usecase_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> initGetIt() async {
  // Shared preferences side:
  SharedPreferences sp = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(sharedPreferences: sp),
  );

  // Image Picker side:
  getIt.registerLazySingleton<ImagePickerUtils>(
    () => ImagePickerUtils(
      imagePicker: ImagePicker(),
      imageCropper: ImageCropper(),
    ),
  );

  // DIO CLIENT side:
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // countries side:
  getIt.registerLazySingleton<CountriesRemoteDatasource>(
    () => CountriesRemoteDatasourceImpl(dio: getIt<DioClient>().countriesDio),
  );
  getIt.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(
      countriesRemoteDatasource: getIt<CountriesRemoteDatasource>(),
    ),
  );
  getIt.registerLazySingleton<GetCountriesUsecase>(
    () => GetCountriesUsecase(countryRepository: getIt<CountriesRepository>()),
  );

  // User side:
  getIt.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(AppDatabase()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userLocalDatasource: getIt<UserLocalDatasource>()),
  );
  getIt.registerLazySingleton<GetUserUsecase>(
    () => GetUserUsecaseImpl(userRepository: getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<InsertUserUsecase>(
    () => InsertUserUsecaseImpl(userRepository: getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<DeleteUserUsecase>(
    () => DeleteUserUsecaseImpl(userRepository: getIt<UserRepository>()),
  );

  // Chat side
  getIt.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasourceImpl(dio: getIt<DioClient>().chatApi),
  );
  getIt.registerLazySingleton<ChatLocalDatasource>(
    () => ChatLocalDatasourceImpl(appDatabase: AppDatabase()),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatRemoteDatasource: getIt<ChatRemoteDatasource>(),
      chatLocalDatasource: getIt<ChatLocalDatasource>(),
    ),
  );
  getIt.registerLazySingleton<SendPromptUsecase>(
    () => SendPromptUsecase(chatRepository: getIt<ChatRepository>()),
  );
  getIt.registerLazySingleton<GetChatsUsecase>(
    () => GetChatsUsecase(chatRepository: getIt<ChatRepository>()),
  );
  getIt.registerLazySingleton<InsertChatUsecase>(
    () => InsertChatUsecase(chatRepository: getIt<ChatRepository>()),
  );
}
