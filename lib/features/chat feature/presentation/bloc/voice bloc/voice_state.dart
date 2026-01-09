import 'package:equatable/equatable.dart';

sealed class VoiceState extends Equatable {
const VoiceState();
  @override
  List<Object?> get props => [];
 
}
class InitialVoice extends VoiceState {
  const InitialVoice();
}

class IsSpeakingVoice extends VoiceState {
  const IsSpeakingVoice();
}

class IsLoadingVoice extends VoiceState {
  const IsLoadingVoice();
}

class IsLoadedVoice extends VoiceState {
  final String reply;
  const IsLoadedVoice({required this.reply});
  @override
  List<Object?> get props => [reply];
}

class IsErrorVoice extends VoiceState {
  final String message;
  const IsErrorVoice({required this.message});
  @override

  List<Object?> get props => [message];

}