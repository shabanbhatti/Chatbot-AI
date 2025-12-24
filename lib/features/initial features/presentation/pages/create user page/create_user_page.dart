import 'package:chatbot_ai/config/DI/injector.dart';
import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_bloc.dart';
import 'package:chatbot_ai/core/bloc/shared%20preferences%20bloc/shared_preferences_event.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:chatbot_ai/core/utils/dialogs%20utils/loading_dialog_util.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/pages/app_main_page.dart';
import 'package:chatbot_ai/features/initial%20features/domain/usecases/get_countries_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/countries%20bloc/countries_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_bloc.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_event.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/user%20bloc/user_state.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/widgets/create_username_widget.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/widgets/img_gender_age_widget.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/pages/create%20user%20page/widgets/select_country_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});
  static const String pageName = 'create_user_page';

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  PageController pageController = PageController();
  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  ValueNotifier<String?> imgPathNotifier = ValueNotifier(null);
  ValueNotifier<String> nameNotifier = ValueNotifier('');
  ValueNotifier<String> genderNotifier = ValueNotifier('');
  ValueNotifier<String> birthNotifier = ValueNotifier('01 Jan 2000');
  late UserBloc userBloc;
  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
    userBloc = UserBloc(
      getUserUsecase: getIt<GetUserUsecase>(),
      insertUserUsecase: getIt<InsertUserUsecase>(),
      deleteUserUsecase: getIt<DeleteUserUsecase>(),
    );
    pages = [
      CreateUserNameWidget(
        controller: nameController,
        onNext: () {
          if (nameController.text.isNotEmpty) {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInCirc,
            );
          } else {
            ShowToast.basicToast(
              message: 'Please type your name here!',
              color: CupertinoColors.destructiveRed,
            );
          }
        },
      ),
      BlocProvider(
        create: (context) =>
            CountriesBloc(getCountriesUsecase: getIt<GetCountriesUsecase>()),
        child: SelectCountryWidget(
          controller: countryController,
          onNext: () {
            if (countryController.text.isNotEmpty) {
              nameNotifier.value = nameController.text.trim();
              pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInCirc,
              );
            } else {
              ShowToast.basicToast(
                message: 'Please select your country here!',
                color: CupertinoColors.destructiveRed,
              );
            }
          },
        ),
      ),

      ValueListenableBuilder(
        valueListenable: nameNotifier,
        builder: (context, value, child) {
          return ImgGenderAgeWidget(
            birthNotifier: birthNotifier,
            genderNotifier: genderNotifier,
            name: value,
            imgPathNotifier: imgPathNotifier,
            birthController: birthController,
            onCreate: () {
              if (birthController.text.isNotEmpty &&
                  genderNotifier.value.isNotEmpty) {
                userBloc.add(
                  InsertUserEvent(
                    UserEntity(
                      name: nameController.text.trim(),
                      dateOfBirth: birthController.text.trim(),
                      gender: genderNotifier.value,
                      country: countryController.text.trim(),
                      userImg: imgPathNotifier.value ?? '',
                      id: DateTime.now().microsecond,
                    ),
                  ),
                );
              } else {
                ShowToast.basicToast(
                  message:
                      'Please check have you selected your gender & Date of birth correctly!',
                  color: CupertinoColors.destructiveRed,
                );
              }
            },
          );
        },
      ),
    ];
  }

  @override
  void dispose() {
    userBloc.close();
    pageController.dispose();
    nameController.dispose();
    countryController.dispose();
    birthController.dispose();
    imgPathNotifier.dispose();
    birthNotifier.dispose();
    nameNotifier.dispose();
    genderNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('create user MAIN page called');
    return BlocListener<UserBloc, UserState>(
      bloc: userBloc,
      listener: (context, state) {
        if (state is UserLoading) {
          showLoadingDialog(context, content: 'Inserting User...');
        }
        if (state is UserInserted) {
          context.read<SharedPreferencesBloc>().add(
            SetBoolEvent(key: SharedPreferencesKEYS.loggedKey, value: true),
          );
          Navigator.pop(context);
          ShowToast.basicToast(message: 'Inserted successfully');

          Navigator.pushNamed(context, AppMainPage.pageName);
        }

        if (state is UserError) {
          ShowToast.basicToast(
            message: state.message,
            color: CupertinoColors.destructiveRed,
          );
          Navigator.pop(context);
        }
      },
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Center(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                  child: pages[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
