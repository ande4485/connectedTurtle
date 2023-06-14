
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

class SoundBoxUseCase {
  final SoundApi soundApi;
  final UploadRepository uploadRepository;
  final MessageRepository boxMessageRepository;

  SoundBoxUseCase(
      {required this.soundApi,
      required this.uploadRepository,
      required this.boxMessageRepository});

  Future<void> initRecorder() {
    return soundApi.initRecorder();
  }

  Future<void> recordAudio() {
    return soundApi.recordAudio();
  }

  Future<void> stopAndSaveAudio(Turtle device, List<String> toId) async {
    List<int> sound = await soundApi.stopAudioRecord();
    if (sound.isNotEmpty) {
      String audioLink =
          await uploadRepository.uploadSoundDatas(sound, device.id);
      VocalMessage message = VocalMessage(
          id: "",
          fromId: device.id,
          fromStr: device.nameDevice,
          to: "",
          date: DateTime.now(),
          link: [audioLink]);
      await boxMessageRepository.sendMessage(message, device.id);
    }
  }
}
