import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/bloc/sound_box_bloc.dart';
import 'package:turtle_box/presentation/screen/wrap_text_widget.dart';
import 'package:turtle_package/model/device.dart';

import 'end_screen.dart';

class VocalRecorderPage extends StatelessWidget {
  final String toId;
  final Turtle currentDevice;
  final bool answerForMessage;
  const VocalRecorderPage(
      {super.key, required this.toId,
      required this.currentDevice,
      required this.answerForMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VocalRecorderScreen(
        toId: toId,
        currentDevice: currentDevice,
        answerForMessage: answerForMessage,
      ),
    );
  }
}

class VocalRecorderScreen extends StatefulWidget {
  final String toId;
  final Turtle currentDevice;
  final bool answerForMessage;
  const VocalRecorderScreen(
      {super.key, required this.toId,
      required this.currentDevice,
      required this.answerForMessage});

  @override
  State<StatefulWidget> createState() => VocalRecorderScreenState();
}

class VocalRecorderScreenState extends State<VocalRecorderScreen> {
  static const STEP_INIT_RECORD = 0;
  static const STEP_RECORD = 1;
  static const STEP_STOP_RECORD = 2;

  int stepVocalRecorder = STEP_INIT_RECORD;
  late SoundBoxBloc _soundBloc;

  @override
  void initState() {
    _soundBloc = BlocProvider.of<SoundBoxBloc>(context);
    _soundBloc.initRecorder();
    BlocProvider.of<BoxBloc>(context).stream.listen((state) async {
      if (state is BoxEventNext) {
        if (stepVocalRecorder == STEP_INIT_RECORD) {
          setState(() {
            stepVocalRecorder = STEP_RECORD;
          });
          _soundBloc.recordAudio();
        } else if (stepVocalRecorder == STEP_RECORD) {
          setState(() {
            stepVocalRecorder = STEP_STOP_RECORD;
          });
          await _soundBloc
              .stopAndSaveAudio(widget.currentDevice, [widget.toId]);
          if (widget.answerForMessage) {
            Navigator.of(context).pop();
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EndPage(currentDevice: widget.currentDevice)));
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (stepVocalRecorder == STEP_INIT_RECORD) {
      return WrapTextWidget(
          message: S.current.press_turtle_when_ready,
          fontSize: widget.currentDevice.fontSize.toDouble());
    } else if (stepVocalRecorder == STEP_RECORD) {
      return WrapTextWidget(
          message: S.current.press_turtle_when_finish,
          fontSize: widget.currentDevice.fontSize.toDouble());
    } else if (stepVocalRecorder == STEP_STOP_RECORD) {
      return WrapTextWidget(
          message: S.current.send_message,
          fontSize: widget.currentDevice.fontSize.toDouble());
    } else {
      return const SizedBox();
    }
  }
}
