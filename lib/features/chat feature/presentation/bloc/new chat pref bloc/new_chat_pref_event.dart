import 'package:equatable/equatable.dart';

sealed class NewChatPrefEvent extends Equatable {
  const NewChatPrefEvent();
  @override
  List<Object?> get props => [];
}

class SetNewChatboolPrefEvent extends NewChatPrefEvent {
  final bool value;
  const SetNewChatboolPrefEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class GetNewChatBoolPref extends NewChatPrefEvent {
  const GetNewChatBoolPref();
}
