import 'package:equatable/equatable.dart';

sealed class VoiceEvent extends Equatable {
  const VoiceEvent();
  @override
  List<Object?> get props => [];
}

class StartRecordingEvent extends VoiceEvent {
  const StartRecordingEvent();
}

class StopRecordingEvent extends VoiceEvent {
  const StopRecordingEvent();
  @override
  List<Object?> get props => [];
}
