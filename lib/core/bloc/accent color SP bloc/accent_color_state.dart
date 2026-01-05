import 'package:equatable/equatable.dart';

class AccentColorState extends Equatable {
  final String colorName;
  const AccentColorState({required this.colorName});

  @override
  List<Object?> get props => [colorName];
}
