import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:turtle_package/domain/sound/sound_api.dart';

class SoundPhoneUseCase {
  final SoundApi soundApi;

  SoundPhoneUseCase({required this.soundApi});

  Future<void> playAudio(Uint8List data) {
    return soundApi.playAudio(data);
  }

  Stream<PlaybackDisposition> getPlayerProgress() {
    return soundApi.getPlayerProgress();
  }

  Future<void> pauseAudio() {
    return soundApi.pauseAudio();
  }

  Future<void> stopPlayAudio() {
    return soundApi.stopPlayAudio();
  }

  Future<void> resumeAudio() {
    return soundApi.resumeAudio();
  }
}
