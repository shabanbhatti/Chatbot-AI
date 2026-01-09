import 'dart:developer';

import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_bloc.dart';
import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_event.dart';
import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_state.dart';
import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:chatbot_ai/core/utils/image_picker_utils.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_app_btn.dart';
import 'package:chatbot_ai/core/widgets/custom%20circle%20avatar%20/custom_circle_avatar_widget.dart';
import 'package:chatbot_ai/core/widgets/custom%20textfields/custom_basic_textfield.dart';
import 'package:chatbot_ai/core/widgets/top_textfield_title_widget.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_bloc.dart';
import 'package:chatbot_ai/features/settings%20feature/presentation/bloc/setting%20bloc/setting_event.dart';
import 'package:chatbot_ai/shared/domain/usecases/get_countries_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key, required this.userEntity});
  final UserEntity userEntity;
  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  late UserEntity userEntity;
  late ValueNotifier<String> imgPathNotifier;
  late TextEditingController nameController;
  late TextEditingController countryController;
  late CountriesBloc countriesBloc;
  ValueNotifier<bool> isShowNotifier = ValueNotifier(false);
  ValueNotifier<bool> isUpdateNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    imgPathNotifier = ValueNotifier(widget.userEntity.userImg);
    countriesBloc = CountriesBloc(
      getCountriesUsecase: getIt<GetCountriesUsecase>(),
    );

    nameController = TextEditingController(text: widget.userEntity.name);
    countryController = TextEditingController(text: widget.userEntity.country);
    userEntity = widget.userEntity;
  }

  @override
  void dispose() {
    countriesBloc.close();
    imgPathNotifier.dispose();
    isShowNotifier.dispose();
    isUpdateNotifier.dispose();
    nameController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('UPDATE USER SHEET BUILD CALLED');
    return SafeArea(
      top: false,
      minimum: EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: imgPathNotifier,
                  builder: (context, value, child) {
                    return CustomCircleAvatarWidget(
                      userName: userEntity.name,
                      imgPath: value,
                      radius: 120,
                      iconHolderRadius: 40,
                      iconSize: 23,

                      onTakeImage: () async {
                        var path = await getIt<ImagePickerUtils>().takeImage(
                          ImageSource.gallery,
                        );
                        log('IMG pATH: $path');
                        if (path != null) {
                          isUpdateNotifier.value = true;
                          imgPathNotifier.value = path;
                        }
                      },
                    );
                  },
                ),
                const TopTextfieldTitleWidget(title: 'Name'),
                CustomBasicTextfield(
                  controller: nameController,
                  title: 'Update name',
                  prefixIcon: CupertinoIcons.person_fill,
                  onChanged: (v) {
                    isUpdateNotifier.value = true;
                  },
                ),

                const TopTextfieldTitleWidget(title: 'Country'),
                CustomBasicTextfield(
                  controller: countryController,
                  title: 'Update country',
                  prefixIcon: CupertinoIcons.placemark_fill,
                  onChanged: (value) {
                    isUpdateNotifier.value = true;
                    if (value.isNotEmpty) {
                      isShowNotifier.value = true;
                    } else {
                      isShowNotifier.value = false;
                    }

                    countriesBloc.add(GetCountriesEvent(name: value));
                  },
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(bottom: 10),
            sliver: ValueListenableBuilder(
              valueListenable: isShowNotifier,
              builder: (context, value, child) {
                return SliverVisibility(
                  visible: value,
                  sliver: BlocBuilder<CountriesBloc, CountriesState>(
                    bloc: countriesBloc,
                    builder: (context, state) {
                      if (state is CountriesLoading) {
                        return const SliverToBoxAdapter(
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      } else if (state is CountriesLoaded) {
                        var data = state.countriesEntity;
                        return SliverList.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return CupertinoListTile(
                              onTap: () {
                                isUpdateNotifier.value = true;
                                countryController.text =
                                    '${data[index].country} ${data[index].flag}';
                                isShowNotifier.value = false;
                              },
                              title: Text(data[index].country),
                              leading: Text(data[index].flag),
                              subtitle: Text(data[index].official),
                            );
                          },
                        );
                      } else if (state is CountriesError) {
                        return SliverToBoxAdapter(
                          child: Center(child: Text(state.message)),
                        );
                      } else {
                        return const SliverToBoxAdapter();
                      }
                    },
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: isShowNotifier,
              builder: (context, value, child) {
                return Visibility(
                  visible: value ? false : true,
                  child: ValueListenableBuilder(
                    valueListenable: isUpdateNotifier,
                    builder: (context, isUpdated, child) {
                      return CustomAppBtn(
                        color: isUpdated
                            ? ColorConstants.appColor
                            : CupertinoColors.inactiveGray,
                        title: 'Update profile',
                        onTap: !isUpdated
                            ? null
                            : () {
                                if (nameController.text.isNotEmpty &&
                                    countryController.text.isNotEmpty) {
                                  context.read<SettingBloc>().add(
                                    UpdateUserInSettingEvent(
                                      userEntity: userEntity.copyWith(
                                        userImg: imgPathNotifier.value,
                                        country: countryController.text.trim(),
                                        name: nameController.text.trim(),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
