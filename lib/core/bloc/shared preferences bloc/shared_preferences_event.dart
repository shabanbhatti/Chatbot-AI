import 'package:equatable/equatable.dart';

abstract class SharedPreferencesEvent extends Equatable {
  @override
  List<Object?> get props => [];
  const SharedPreferencesEvent();
}

class SetBoolEvent extends SharedPreferencesEvent {
  final String key;
  final bool value;
  const SetBoolEvent({required this.key, required this.value});
}

class GetBoolEvent extends SharedPreferencesEvent {
  final String key;
  const GetBoolEvent({required this.key});
}
