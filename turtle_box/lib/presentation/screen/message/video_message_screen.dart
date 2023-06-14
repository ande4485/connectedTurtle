import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/design/constant.dart';
import 'package:turtle_package/model/message.dart';
import 'package:turtle_package/presentation/widget/video_widget.dart';
import 'package:video_player/video_player.dart';

import 'message_widget.dart';

///widget for video message
class VideoMessagePage extends StatelessWidget {
  final VideoMessage message;
  final int fontSize;

  const VideoMessagePage(
      {super.key, required this.message, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoMessageScreen(message: message, fontSize: fontSize),
    );
  }
}

class VideoMessageScreen extends StatefulWidget {
  final VideoMessage message;
  final int fontSize;

  const VideoMessageScreen(
      {super.key, required this.message, required this.fontSize});

  @override
  VideoMessageScreenState createState() => VideoMessageScreenState();
}

class VideoMessageScreenState extends State<VideoMessageScreen> {
  int indexLink = -1;
  bool showMessage = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(
        buildWhen: (oldState, newState) => newState is BoxEventNext,
        builder: (context, state) {
          if (showMessage) {
            showMessage = false;
            return MessageWidget(
                messageFrom: widget.message.fromStr,
                message: widget.message.message,
                fontSize: widget.fontSize.toDouble());
          } else {
            indexLink++;
            if (indexLink >= widget.message.link.length) {
              return const SizedBox();
            } else {
              return Center(
                  child: VideoWidget(
                autoRun: true,
                errorWidget: Text(S.current.error_loading),
                waitingWidget: Text(S.current.waiting_loading),
              ));
            }
          }
        },
        listenWhen: (oldState, newState) =>
            newState is BoxEventNext ||
            newState is BoxTimeOut ||
            newState is BoxTimeOutStop ||
            newState is BoxStart,
        listener: (context, state) {
          if (state is BoxEventNext) {
            if (indexLink == widget.message.link.length - 1) {
              Navigator.of(context).pop(false);
            }
          } else if (state is BoxTimeOut) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(S.current.press_turtle, key: const Key("timeout")),
              duration: snapBarDuration,
            ));
          } else if (state is BoxTimeOutStop) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          } else if (state is BoxStart) {
            Navigator.of(context).pop(true);
          }
        });
  }
}
