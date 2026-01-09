import 'dart:developer';

import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_bloc.dart';
import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_event.dart';
import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_state.dart';
import 'package:chatbot_ai/core/constants/image_path_constants.dart';
import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/core/widgets/custom%20btns/custom_app_btn.dart';
import 'package:chatbot_ai/core/widgets/custom%20textfields/custom_basic_textfield.dart';
import 'package:chatbot_ai/core/widgets/top_textfield_title_widget.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCountryWidget extends StatefulWidget {
  const SelectCountryWidget({
    super.key,
    required this.controller,
    required this.onNext,
  });
  final TextEditingController controller;
  final OnPressed onNext;

  @override
  State<SelectCountryWidget> createState() => _SelectCountryWidgetState();
}

class _SelectCountryWidgetState extends State<SelectCountryWidget> {
  ValueNotifier<bool> isShow = ValueNotifier(false);
  @override
  void dispose() {
    isShow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('country widget called');
    return BlocListener<CountriesBloc, CountriesState>(
      listener: (context, state) {
        if (state is CountriesError) {
          ShowToast.basicToast(
            message: state.message,
            color: CupertinoColors.destructiveRed,
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 20),
          ),
          SliverPadding(
            padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Hero(
                tag: 'move',
                child: Image.asset(
                  ImagePathConstants.appLogo,
                  height: 150,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsGeometry.only(top: 20, bottom: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const TopTextfieldTitleWidget(title: 'Country'),
                  CustomBasicTextfield(
                    controller: widget.controller,
                    title: 'Select country',
                    prefixIcon: CupertinoIcons.placemark_fill,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        isShow.value = true;
                      } else {
                        isShow.value = false;
                      }

                      context.read<CountriesBloc>().add(
                        GetCountriesEvent(name: value),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: isShow,
            builder: (context, value, child) {
              return SliverPadding(
                padding: EdgeInsetsGeometry.only(bottom: 10),
                sliver: SliverVisibility(
                  visible: value,
                  sliver: BlocBuilder<CountriesBloc, CountriesState>(
                    buildWhen: (previous, current) {
                      print('====================');
                      print(
                        'PREVIOUS: ${previous.runtimeType} | CURRENT: ${current.runtimeType}',
                      );
                      if (current is CountriesLoading) {
                        return true;
                      } else if (previous is CountriesLoading &&
                          current is CountriesLoaded) {
                        return true;
                      }else if(current is CountriesError){
                        return true;
                      }else if(previous is CountriesLoaded && current is CountriesLoaded){
                        return previous.countriesEntity!=current.countriesEntity;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      log('countries bloc called');
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
                                widget.controller.text =
                                    '${data[index].country} ${data[index].flag} ';
                                isShow.value = false;
                              },
                              title: Text(data[index].country),
                              leading: Text(
                                data[index].flag,
                                style: TextStyle(fontSize: 25),
                              ),
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
                ),
              );
            },
          ),

          SliverPadding(
            padding: const EdgeInsetsGeometry.symmetric(vertical: 0),
            sliver: SliverToBoxAdapter(
              child: CustomAppBtn(title: 'Next', onTap: widget.onNext),
            ),
          ),
        ],
      ),
    );
  }
}
