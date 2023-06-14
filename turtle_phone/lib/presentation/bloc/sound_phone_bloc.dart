import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:turtle_phone/presentation/bloc/sound_state.dart';

import '../../domain/usecase/sound_phone_usecase.dart';

class SoundPhoneBloc extends Cubit<SoundState> {
  final SoundPhoneUseCase soundUseCase;

  SoundPhoneBloc({required this.soundUseCase}) : super(SoundInit());

  Future<void> playAudio(Uint8List data) {
    return soundUseCase.playAudio(data);
  }

  Stream<PlaybackDisposition> getPlayerProgress() {
    return soundUseCase.getPlayerProgress();
  }

  Future<void> pauseAudio() {
    return soundUseCase.pauseAudio();
  }

  Future<void> resumeAudio() {
    return soundUseCase.resumeAudio();
  }

  Future<void> stopPlayAudio() {
    return soundUseCase.stopPlayAudio();
  }
}
