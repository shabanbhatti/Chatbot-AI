import 'package:equatable/equatable.dart';

abstract class AccentColorEvent extends Equatable {
  @override
  List<Object?> get props => [];
  const AccentColorEvent();
}

class SetColorEvent extends AccentColorEvent {
  final String key;
  final String value;
  const SetColorEvent({required this.key, required this.value});
  @override
  List<Object?> get props => [key, value];
}

class GetColorEvent extends AccentColorEvent {
  const GetColorEvent();
}
