import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/config/routes/routes.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_bloc.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_state.dart';
import 'package:chatbot_ai/core/providers/providers.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/intro%20page/intro_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Bloc.observer = MyBlocObserver();
  await initGetIt();
  runApp(Providers.mainFileGlobalProviders(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) {
        if (previous.theme != current.theme) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        return CupertinoApp(
          builder: EasyLoading.init(),
          theme: state.theme,
          debugShowCheckedModeBanner: false,
          initialRoute: IntroPage.pageName,
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
