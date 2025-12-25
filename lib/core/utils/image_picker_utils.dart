import 'dart:developer';

import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  final ImagePicker imagePicker;
  final ImageCropper imageCropper;
  const ImagePickerUtils({
    required this.imagePicker,
    required this.imageCropper,
  });

  Future<String?> takeImage(ImageSource imageSource, ) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: imageSource);
      if (pickedFile == null) return null;

      final croppedFile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: ColorConstants.appColor,
            toolbarWidgetColor: CupertinoColors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
        ],
      );
      if (croppedFile == null) return null;
      return croppedFile.path;
    } catch (e) {
      log('Error picking/cropping image: $e');
      return null;
    }
  }
}
