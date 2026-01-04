import 'dart:developer';

import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_bloc.dart';
import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_event.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_bloc.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_event.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_state.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/utils/model%20bottom%20sheet/bottom_sheet_ios_utils.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/custom_basic_listtile.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_outlined_btn.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/custom_circle_avatar_widget.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/loading_effect_circle_avatar_widget.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/show_img_circle_avatar_widget.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_bloc.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_state.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/update_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    print('SETTING SHEET BUILD CALLED');
    return BlocListener<ThemeBloc, ThemeState>(
      listener: (context, state) {
        if (state.themeDarkLight == ThemeDarkLight.light) {
          print('LIGHT');
          context.read<SharedPreferencesBloc>().add(
            SetBoolEvent(key: SharedPreferencesKEYS.themeKey, value: true),
          );
        } else {
          print('DARK');
          context.read<SharedPreferencesBloc>().add(
            SetBoolEvent(key: SharedPreferencesKEYS.themeKey, value: false),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: BlocBuilder<SettingBloc, SettingState>(
                builder: (context, state) {
                  if (state is LoadingSettingState) {
                    return const LoadingEffectCircleAvatarWidget();
                  } else if (state is LoadedUserInSettingState) {
                    var user = state.userEntity;
                    log('ID in UI: ${user.id.toString()}');
                    log(user.userImg);
                    return ShowImgCircleAvatarWidget(
                      userName: user.name,
                      imgPath: user.userImg,
                      radius: 150,
                      internalFontSize: 30,
                    );
                  } else {
                    return CustomCircleAvatarWidget(
                      userName: 'No Username',
                      imgPath: '',
                      onTakeImage: () {},
                    );
                  }
                },
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsetsGeometry.only(top: 17),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: BlocBuilder<SettingBloc, SettingState>(
                  builder: (context, state) {
                    if (state is LoadingSettingState) {
                      return const Skeletonizer(child: Text('Loading...'));
                    } else if (state is LoadedUserInSettingState) {
                      return Column(
                        mainAxisSize: .min,
                        children: [
                          Text(
                            state.userEntity.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            state.userEntity.country,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(color: CupertinoColors.systemGrey),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Center(
              child: CustomOutlinedBtn(
                title: 'Update Profile',
                width: 100,
                height: 30,
                fontSize: 11,
                onTap: () {
                  var loadedUser =
                      context.read<SettingBloc>().state
                          as LoadedUserInSettingState;
                  var user = loadedUser.userEntity;
                  log('${user.name} ${user.country}');
                  showCupertinoFullSheet(
                    context,
                    sheetHeightThroughMediaQuery: 0.5,
                    child: UpdateUserPage(userEntity: user),

                    pageName: 'Update profile',
                  );
                },
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 0),
            sliver: SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                backgroundColor: CupertinoColors.transparent,

                children: [
                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.calendar,
                    title: 'Date of birth',
                    onTap: null,
                  ),
                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.person,
                    title: 'Gender',
                    onTap: null,
                  ),
                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.bell,
                    title: 'Notifications',
                    onTap: null,
                  ),

                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.delete,
                    title: 'Delete chats',
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 0),
            sliver: SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                backgroundColor: CupertinoColors.transparent,

                children: [
                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.globe,
                    title: 'Language',
                    onTap: null,
                    trailing: Text('English'),
                  ),

                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.lightbulb,
                    title: SharedPreferencesKEYS.themeKey,
                    onTap: null,
                    trailing: BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            context.read<ThemeBloc>().add(ToggeledTheme());
                          },
                          child: Icon(CupertinoIcons.circle_righthalf_fill),
                        );
                      },
                    ),
                  ),

                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.circle_grid_hex,
                    title: 'Accent color',
                    onTap: () {},
                    trailing: Text('🟠 Orange'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
