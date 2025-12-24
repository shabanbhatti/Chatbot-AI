import 'dart:io';

import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppMainPage extends StatelessWidget {
  const AppMainPage({super.key});
  static const String pageName = '/app_main_page';
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return Column(
                    children: [
                      Text(state.user.country),
                      Image.file(File(state.user.userImg)),
                      Text(state.user.dateOfBirth),
                    ],
                  );
                } else {
                  return Text('data');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
