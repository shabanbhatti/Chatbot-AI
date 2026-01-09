import 'dart:developer';

import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_state.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_bloc.dart';
import 'package:chatbot_ai/core/bloc/theme%20bloc/theme_event.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/utils/model%20bottom%20sheet/bottom_sheet_ios_utils.dart';
import 'package:chatbot_ai/core/widgets/Custom%20ListTiles%20widgets/custom_basic_listtile.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_outlined_btn.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/custom_circle_avatar_widget.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/loading_effect_circle_avatar_widget.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/show_img_circle_avatar_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_bloc.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_state.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/pages/update_user_page.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/utils/accent_color_model_popup_util.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/widgets/chat_background_sheet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // context.read<SettingBloc>().add(GetChatbackgroundImgsPathsEvent());
  }

  @override
  Widget build(BuildContext context) {
    print('SETTING SHEET BUILD CALLED');
    return BlocListener<SettingBloc, SettingState>(
      // listenWhen: (previous, current) {

      // },
      listener: (context, state) {
        if (state is LoadedSettingState) {
          context.read<ChatBloc>().add(GetChatsEvent());
        }
      },

      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: BlocBuilder<SettingBloc, SettingState>(
                buildWhen: (previous, current) {
                  print(
                    'PREVIOUS: ${previous.runtimeType} | CURRENT: ${current.runtimeType}',
                  );
                  if (previous is InitialSettingState &&
                      current is LoadingSettingState) {
                    return true;
                  } else if (previous is LoadingSettingState &&
                      current is LoadedSettingState) {
                    return true;
                  } else if (previous is LoadedSettingState &&
                      current is LoadedSettingState) {
                    return previous.userEntity?.userImg !=
                        current.userEntity?.userImg;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  log('AVATAR CALLED BLOC');
                  if (state is LoadingSettingState) {
                    return const LoadingEffectCircleAvatarWidget();
                  } else if (state is LoadedSettingState) {
                    var user = state.userEntity!;
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
                  buildWhen: (previous, current) {
                    if (previous is InitialSettingState &&
                        current is LoadingSettingState) {
                      return true;
                    } else if (previous is LoadingSettingState &&
                        current is LoadedSettingState) {
                      return true;
                    } else if (previous is LoadedSettingState &&
                        current is LoadedSettingState) {
                      return previous.userEntity?.name !=
                          current.userEntity?.name;
                    } else if (previous is LoadedSettingState &&
                        current is LoadedSettingState) {
                      return previous.userEntity?.country !=
                          current.userEntity?.country;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    print('USER & FLAG BLOC CALLED');
                    if (state is LoadingSettingState) {
                      return _loadingNameAndCountryWidget();
                    } else if (state is LoadedSettingState) {
                      return Column(
                        mainAxisSize: .min,
                        children: [
                          Text(
                            state.userEntity!.name,
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
                            state.userEntity!.country,
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
                      context.read<SettingBloc>().state as LoadedSettingState;
                  var user = loadedUser.userEntity!;
                  // log('${user.name} ${user.country}');
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
                    trailing: BlocBuilder<SettingBloc, SettingState>(
                      buildWhen: (previous, current) {
                        if (previous is InitialSettingState &&
                            current is LoadingSettingState) {
                          return true;
                        } else if (previous is LoadingSettingState &&
                            current is LoadedSettingState) {
                          return true;
                        } else if (previous is LoadedSettingState &&
                            current is LoadedSettingState) {
                          return previous.userEntity?.dateOfBirth !=
                              current.userEntity?.dateOfBirth;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        print('DATE OF BIRTH BLOC CALLED');
                        if (state is LoadingSettingState) {
                          return const Skeletonizer(child: Text('Loading...'));
                        } else if (state is LoadedSettingState) {
                          return Text(state.userEntity!.dateOfBirth);
                        } else {
                          return const Text('No birth found');
                        }
                      },
                    ),
                  ),
                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.person,
                    title: 'Gender',
                    onTap: null,
                    trailing: BlocBuilder<SettingBloc, SettingState>(
                      buildWhen: (previous, current) {
                        if (previous is InitialSettingState &&
                            current is LoadingSettingState) {
                          return true;
                        } else if (previous is LoadingSettingState &&
                            current is LoadedSettingState) {
                          return true;
                        } else if (previous is LoadedSettingState &&
                            current is LoadedSettingState) {
                          return previous.userEntity?.gender !=
                              current.userEntity?.gender;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        print('Gender BLOC CALLED');
                        if (state is LoadingSettingState) {
                          return const Skeletonizer(child: Text('Loading...'));
                        } else if (state is LoadedSettingState) {
                          return Text(state.userEntity!.gender);
                        } else {
                          return const Text('No gender found');
                        }
                      },
                    ),
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
                    leadingIcon: CupertinoIcons.sun_max,
                    title: SharedPreferencesKEYS.themeKey,
                    onTap: () {
                      context.read<ThemeBloc>().add(ToggeledTheme());
                    },
                    trailing: GestureDetector(
                      onTap: () {
                        context.read<ThemeBloc>().add(ToggeledTheme());
                      },
                      child: const Icon(CupertinoIcons.circle_righthalf_fill),
                    ),
                  ),

                  BlocBuilder<AccentColorBloc, AccentColorState>(
                    buildWhen: (previous, current) {
                      if (previous.colorName != current.colorName) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      return CustomBasicListtile(
                        leadingIcon: CupertinoIcons.circle_grid_hex,
                        title: 'Accent color',
                        onTap: () {
                          showSheet(context);
                        },
                        trailing: Text(state.colorName),
                      );
                    },
                  ),

                  CustomBasicListtile(
                    leadingIcon: CupertinoIcons.paintbrush,
                    title: 'Chat background theme',
                    onTap: () {
                      showCupertinoFullSheet(
                        context,
                        pageName: 'Chat background theme',
                        child: ChatBackgroundSheetWidget(),
                        sheetHeightThroughMediaQuery: 0.6,
                      );
                    },
                    trailing: const Text('Default'),
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

Widget _loadingNameAndCountryWidget() {
  return const Column(
    mainAxisSize: .min,
    children: [
      Skeletonizer(
        child: Text('Loading...', maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      SizedBox(height: 5),
      Skeletonizer(child: Text('Loading...')),
    ],
  );
}
