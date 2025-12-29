import 'dart:async';
import 'dart:developer';

import 'package:chatbot_ai/core/constants/constant_colors.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/core/utils/get_paths_dir_method_utils.dart';
import 'package:chatbot_ai/core/utils/show_toast.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/voice_to_text_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/voice%20bloc/voice_state.dart';
import 'package:flutter/cupertino.dart';
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
    : super(
        VoiceState(
          path: '',
          isSpeaking: false,
          error: '',
          isError: false,
          isLoaded: false,
          isLoading: false,
          reply: '',
        ),
      ) {
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
      emit(
        state.copyWith(
          isSpeaking: true,
          reply: '',
          error: '',
          isError: false,
          isLoaded: false,
          isLoading: false,
          path: '',
        ),
      );

      var path = await GetPath.getPathForAudio();
      audioRecorder.start(const RecordConfig(), path: path);
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        totalSeconds++;
        ShowToast.basicToast(
          message: 'Recording started 🎤: $timerString',

          color: ColorConstants.appColor,
          gravity: ToastGravity.BOTTOM,
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

      if (totalSeconds < 5) {
        ShowToast.basicToast(
          message: "🔇 Voice should be more than 5 seconds",
          color: CupertinoColors.destructiveRed,
          duration: 3,
        );
        emit(state.copyWith(isSpeaking: false));
        return;
      }

      log('Path: $path');
      emit(state.copyWith(isLoading: true, isSpeaking: false));

      // var reply = await voiceToTextUsecase(File(path!));
      throw ApiFailure(message: 'Fuck hugaaya');

      // emit(state.copyWith(isLoaded: true, reply: 'reply', isLoading: false));
    } on Failures catch (e) {
      emit(
        VoiceState(
          path: '',
          isSpeaking: false,
          isLoading: false,
          isLoaded: false,
          error: e.message,
          isError: true,
          reply: '',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    timer?.cancel();
    audioRecorder.dispose();
    return super.close();
  }
}
