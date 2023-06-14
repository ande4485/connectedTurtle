import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';

class SoundImpl extends SoundApi {
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  List<int> _buffer = [];
  StreamController<Food>? _stream;
  StreamSubscription? _mRecordingDataSubscription;
  Future<void> playAudio(Uint8List data) async {
    if (_mPlayer!.isPlaying) {
      await stopPlayAudio();
    }
    await _mPlayer!.openPlayer();
    await _mPlayer!.setSubscriptionDuration(const Duration(milliseconds: 200));
    await _mPlayer!.startPlayer(fromDataBuffer: data);
  }

  Stream<PlaybackDisposition> getPlayerProgress() {
    return _mPlayer!.onProgress!;
  }

  Future<void> stopPlayAudio() async {
    await _mPlayer!.stopPlayer();
    await _mPlayer!.closePlayer();
  }

  Future<void> initRecorder() async {
    if (_mRecorder == null) _mRecorder = FlutterSoundRecorder();

    await _mRecorder!.openRecorder();
  }

  @override
  Future<void> recordAudio() async {
    print("record sound");

    _stream = StreamController<Food>();
    _mRecordingDataSubscription = _stream!.stream.listen((buffer) {
      if (buffer is FoodData) {
        print("get sound event");
        _buffer.addAll(List<int>.from(buffer.data!));
      }
    });

    //TODO create try catch here if there's no microphone
    await _mRecorder!.startRecorder(toStream: _stream!.sink
        /** numChannels: 1,
      sampleRate: tSampleRate,**/
        );
  }

  @override
  Future<List<int>> stopAudioRecord() async {
    await _mRecorder!.closeRecorder();
    _mRecorder = null;
    await _mRecordingDataSubscription!.cancel();
    await _stream!.close();
    return _buffer;
  }

  @override
  Future<void> pauseAudio() async {
    return await _mPlayer!.pausePlayer();
  }

  @override
  Future<void> resumeAudio() async {
    return await _mPlayer!.resumePlayer();
  }
}
