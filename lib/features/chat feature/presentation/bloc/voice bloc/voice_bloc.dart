import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/utils/get_paths_dir_method_utils.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/voice_to_text_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  AudioRecorder audioRecorder;

  final VoiceToTextUsecase voiceToTextUsecase;

  VoiceBloc({required this.audioRecorder, required this.voiceToTextUsecase})
    : super(InitialVoice()) {
    on<StartRecordingEvent>(onStartRecordingEvent);
    on<StopRecordingEvent>(onStopRecordingEvent);
  }

  Future<void> onStartRecordingEvent(
    StartRecordingEvent event,
    Emitter<VoiceState> emit,
  ) async {
    try {
      var permission = await audioRecorder.hasPermission();
      if (permission) {
        emit(IsSpeakingVoice());

        var path = await GetPath.getPathForAudio();
        audioRecorder.start(const RecordConfig(), path: path);
      } else {
        await Permission.location.request();
        await openAppSettings();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> onStopRecordingEvent(
    StopRecordingEvent event,
    Emitter<VoiceState> emit,
  ) async {
    try {
      var path = await audioRecorder.stop();

      // log('Path: $path');
      emit(IsLoadingVoice());

      var reply = await voiceToTextUsecase(File(path!));

      emit(IsLoadedVoice(reply: reply));
    } on Failures catch (e) {
      emit(IsErrorVoice(message: e.message));
    }
  }

  @override
  Future<void> close() {
    audioRecorder.dispose();
    return super.close();
  }
}
