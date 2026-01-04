import 'dart:async';
import 'dart:developer';

import 'package:chatbot_ai/core/bloc/image%20picker%20bloc/image_picker_event.dart';
import 'package:chatbot_ai/core/bloc/image%20picker%20bloc/image_picker_state.dart';
import 'package:chatbot_ai/core/utils/image_picker_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePickerUtils imagePickerUtils;
  ImagePickerBloc({required this.imagePickerUtils})
    : super(ImagePickerState(imgPath: null)) {
    on<PickImageEvent>(onPickImageEvent);
  }

  Future<void> onPickImageEvent(
    PickImageEvent event,
    Emitter<ImagePickerState> emit,
  ) async {
    try {
      var imgPath = await imagePickerUtils.takeImage(event.imageSource);
      emit(ImagePickerState(imgPath: imgPath));
    } catch (e) {
      log(e.toString());
    }
  }
}
