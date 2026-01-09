import 'dart:developer';

import 'package:chatbot_ai/core/utils/model%20bottom%20sheet/bottom_sheet_ios_utils.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/custom_user_listtile_widget.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/loading_effect_listtile_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_state.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/drawer/widgets/theme_container.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CupertinoDrawer extends StatelessWidget {
  const CupertinoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    log('DRAWER PAGE BUILD CALLED');

    return ThemeContainer(
      darkColor: CupertinoColors.darkBackgroundGray,
      lightColor: CupertinoColors.inactiveGray.withAlpha(25),
      child: SafeArea(
        child: Column(
          children: [
            Container(height: 100, color: CupertinoColors.transparent),
            Expanded(child: CustomScrollView(slivers: [
        
                ]
            )),
            BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) {
                if (current is LoadingChat) {
                  return true;
                } else if (previous is LoadingChat && current is LoadedChat) {
                  return true;
                } else if (previous is LoadedChat && current is LoadedChat) {
                  return previous.userEntity != current.userEntity;
                }
                return false;
              },
              builder: (context, state) {
                if (state is LoadingChat) {
                  return const LoadingUserListtileEffectWidget();
                } else if (state is LoadedChat) {
                  var chatEntity = state.userEntity;
                  return CustomUserListtileWidget(
                    username: chatEntity.name,
                    imgPath: chatEntity.userImg,
                    onTap: () {
                      showCupertinoFullSheet(
                        context,
                        child: const SettingsPage(),
                        pageName: 'Settings',
                      );
                    },
                  );
                } else {
                  return const CustomUserListtileWidget(
                    username: 'No Username',
                    imgPath: '',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
