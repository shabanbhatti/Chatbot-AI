import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/config/routes/routes.dart';
import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_bloc.dart';
import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_event.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/theme/theme.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/intro%20page/intro_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initGetIt();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SharedPreferencesBloc>(
          create: (context) => SharedPreferencesBloc(
            sharedPreferencesService: getIt<SharedPreferencesService>(),
          )..add(GetBoolEvent(key: SharedPreferencesKEYS.loggedKey)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: IntroPage.pageName,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
