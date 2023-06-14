import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_state.dart';

import '../../../bloc/sound_phone_bloc.dart';
import '../../design/color.dart';

class SoundMessageView extends StatefulWidget {
  const SoundMessageView({super.key});

  @override
  State<StatefulWidget> createState() => SoundMessageViewState();
}

class SoundMessageViewState extends State<SoundMessageView>
    with TickerProviderStateMixin {
  late StreamSubscription _streamSubscription;
  late SoundPhoneBloc _soundPhoneBloc;
  bool playing = false;
  double progressValue = 0.0;
  late AnimationController controller;

  @override
  void initState() {
    _soundPhoneBloc = BlocProvider.of<SoundPhoneBloc>(context);

    BlocProvider.of<DownloadBloc>(context).soundDownload();
    super.initState();
  }

  _playAudio(Uint8List data) async {
    _soundPhoneBloc.playAudio(data);
    _streamSubscription =
        _soundPhoneBloc.getPlayerProgress().listen((playBack) {
      if (playing) {
        if (playBack.position.inSeconds == playBack.duration.inSeconds) {
          setState(() {
            playing = false;
            progressValue = 1.0;
          });
          _streamSubscription.cancel();
        } else {
          setState(() {
            progressValue = playBack.position.inMilliseconds /
                playBack.duration.inMilliseconds;
          });
        }
      }
    });
    setState(() {
      playing = true;
      progressValue = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        if (state is DownloadedSound) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.0)),
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  !playing
                      ? IconButton(
                          onPressed: () => _playAudio(state.data),
                          icon: const Icon(Icons.play_circle_outline),
                        )
                      : IconButton(
                          onPressed: () => _soundPhoneBloc.pauseAudio(),
                          icon: const Icon(Icons.pause_circle_outline),
                        ),
                  Container(
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(width: 1.0)),
                      child: LinearProgressIndicator(
                        backgroundColor: grey_color,
                        color: Theme.of(context).colorScheme.onBackground,
                        minHeight: 10,
                        //valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        value: progressValue,
                      ))
                ],
              ));
        } else if (state is DownloadingSound) {
          return const CircularProgressIndicator();
        } else {
          return const Icon(Icons.close_sharp);
        }
      },
    );
  }
}
