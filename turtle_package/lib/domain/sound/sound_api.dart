import 'dart:typed_data';

import 'package:flutter_sound/public/flutter_sound_player.dart';

abstract class SoundApi {
  Future<void> recordAudio();

  Stream<PlaybackDisposition> getPlayerProgress();

  Future<void> playAudio(Uint8List data);

  Future<List<int>> stopAudioRecord();

  Future<void> initRecorder();

  Future<void> resumeAudio();

  Future<void> pauseAudio();

  Future<void> stopPlayAudio();
}
