import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends ImagePickerEvent {
  final ImageSource imageSource;
  const PickImageEvent({required this.imageSource});
  @override
  List<Object?> get props => [imageSource];
}
