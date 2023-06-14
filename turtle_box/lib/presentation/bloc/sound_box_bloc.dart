import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/domain/usecase/sound_box_usecase.dart';
import 'package:turtle_box/presentation/bloc/sound_state.dart';
import 'package:turtle_package/model/device.dart';

class SoundBoxBloc extends Cubit<SoundState> {
  final SoundBoxUseCase soundUseCase;

  SoundBoxBloc({required this.soundUseCase}) : super(SoundInit());

  Future<void> initRecorder() {
    return soundUseCase.initRecorder();
  }

  Future<void> recordAudio() {
    return soundUseCase.recordAudio();
  }

  Future<void> stopAndSaveAudio(Turtle device, List<String> toId) {
    return soundUseCase.stopAndSaveAudio(device, toId);
  }
}
