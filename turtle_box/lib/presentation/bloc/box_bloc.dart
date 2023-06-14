import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';

import 'box_state.dart';

class BoxBloc extends Cubit<BoxState> {
  final BoxUseCase boxUseCase;

  BoxBloc({required this.boxUseCase}) : super(BoxInit()) {
    start();
  }

  nextDiapo() {
    emit(BoxDiapoNext());
  }

  String getDeviceId() {
    return boxUseCase.currentDeviceId;
  }

  BoxState getBoxState() {
    return boxUseCase.boxState;
  }

  void restart() {
    return boxUseCase.restart();
  }

  Future<void> start() async {
    try {
      boxUseCase.start();
      boxUseCase.boxEvent().listen((event) {

        emit(event);
      });
    } catch (e) {
      print("error:$e");
    }
  }

  dispose() {
    boxUseCase.dispose();
  }
}
