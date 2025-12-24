import 'package:equatable/equatable.dart';

class SharedPreferencesState extends Equatable {
  final bool boolValue;
  const SharedPreferencesState({required this.boolValue});
  @override
  List<Object?> get props => [boolValue];
}
