import 'package:equatable/equatable.dart';

class ImagePickerState extends Equatable {
  final String? imgPath;
  const ImagePickerState({required this.imgPath});
  @override
  List<Object?> get props => [imgPath];
}
