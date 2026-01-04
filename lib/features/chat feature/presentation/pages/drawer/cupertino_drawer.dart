import 'dart:developer';

import 'package:chatbot_ai/core/constants/custom_theme_control_constants.dart';
import 'package:chatbot_ai/core/utils/model%20bottom%20sheet/bottom_sheet_ios_utils.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/custom_user_listtile_widget.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/loading_effect_listtile_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_state.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CupertinoDrawer extends StatefulWidget {
  const CupertinoDrawer({super.key});

  @override
  State<CupertinoDrawer> createState() => _CupertinoDrawerState();
}

class _CupertinoDrawerState extends State<CupertinoDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetChatsEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: CupertinoDynamicColor.resolve(
        CustomThemeControl.drawerColor,
        context,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(height: 100, color: CupertinoColors.transparent),
            Expanded(child: CustomScrollView(slivers: [
        
                ]
            )),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                log('DRAWER BLOC CALLED');
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
