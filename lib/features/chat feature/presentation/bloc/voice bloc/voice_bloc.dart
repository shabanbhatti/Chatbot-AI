import 'dart:async';
import 'dart:io';

import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/utils/get_paths_dir_method_utils.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/voice_to_text_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  AudioRecorder audioRecorder;
  int totalSeconds = 0;

  final VoiceToTextUsecase voiceToTextUsecase;
  Timer? timer;
  VoiceBloc({required this.audioRecorder, required this.voiceToTextUsecase})
    : super(InitialVoice()) {
    on<StartRecordingEvent>(onStartRecordingEvent);
    on<StopRecordingEvent>(onStopRecordingEvent);
  }
  String get timerString {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> onStartRecordingEvent(
    StartRecordingEvent event,
    Emitter<VoiceState> emit,
  ) async {
    timer?.cancel();
    totalSeconds = 0;
    var permission = await audioRecorder.hasPermission();
    if (permission) {
      emit(IsSpeakingVoice());

      var path = await GetPath.getPathForAudio();
      audioRecorder.start(const RecordConfig(), path: path);
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        totalSeconds++;
        ShowToast.basicToast(
          message: 'Recording started 🎤: $timerString',

          color: ColorConstants.appColor,
          gravity: ToastGravity.TOP,
        );
      });
    } else {
      await Permission.location.request();
      await openAppSettings();
    }
  }

  Future<void> onStopRecordingEvent(
    StopRecordingEvent event,
    Emitter<VoiceState> emit,
  ) async {
    try {
      var path = await audioRecorder.stop();
      timer?.cancel();

      if (totalSeconds < 3) {
        emit(IsErrorVoice(message: '🔇 Voice should be more than 2 seconds'));
        return;
      }

      // log('Path: $path');
      emit(IsLoadingVoice());

      var reply = await voiceToTextUsecase(File(path!));
      // throw ApiFailure(message: 'ERROR FOUND (hardcode)');
      // await Future.delayed(Duration(seconds: 2));

      emit(
        IsLoadedVoice(
          reply: reply,
          // 'Sorry! Currently, work is in progress on the app, so this service is temporarily disabled 😊',
        ),
      );
    } on Failures catch (e) {
      emit(IsErrorVoice(message: e.message));
    }
  }

  @override
  Future<void> close() {
    timer?.cancel();
    audioRecorder.dispose();
    return super.close();
  }
}
