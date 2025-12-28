import 'package:equatable/equatable.dart';

class VoiceState extends Equatable {
  final String path;
  final bool isSpeaking;
  final bool isLoading;
  final bool isLoaded;
  final String error;
  final bool isError;
  final String reply;
  const VoiceState({
    required this.path,
    required this.isSpeaking,
    required this.isLoading,
    required this.isLoaded,
    required this.error,
    required this.isError,
    required this.reply,
  });
  VoiceState copyWith({
    String? path,
    bool? isSpeaking,
    String? error,
    bool? isLoading,
    bool? isLoaded,
    bool? isError,
    String? reply,
  }) {
    return VoiceState(
      path: path ?? this.path,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      error: error ?? this.error,
      isError: isError ?? this.isError,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
      reply: reply ?? this.reply,
    );
  }

  @override
  List<Object?> get props => [
    path,
    isSpeaking,
    isError,
    isLoading,
    isLoaded,
    reply,
    error,
  ];
}
