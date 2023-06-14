import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';
import 'package:turtle_package/presentation/bloc/download_state.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final Widget waitingWidget;
  final Widget errorWidget;
  final bool autoRun;
  VideoWidget(
      {required this.errorWidget,
      required this.waitingWidget,
      required this.autoRun});

  @override
  State<StatefulWidget> createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? videoCtrl;

  @override
  void dispose() {
    if (videoCtrl != null) videoCtrl!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<DownloadBloc>(context).videoDownload();
    super.initState();
  }

  Future<VideoPlayerController> getVideoController(Uint8List datas) async {
    videoCtrl = VideoPlayerController.file(File.fromRawPath(datas));
    await videoCtrl!.initialize();
    if (widget.autoRun) {
      videoCtrl!.play();
    }
    return videoCtrl!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(builder: (context, state) {
      if (state is DownloadingVideo) {
        return widget.waitingWidget;
      } else if (state is DownloadedVideo) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return widget.errorWidget;
            } else if (snapshot.data != null) {
              return VideoPlayer(snapshot.data!);
            } else {
              return widget.waitingWidget;
            }
          },
          future: getVideoController(state.data),
        );
      } else {
        return widget.errorWidget;
      }
    });
  }
}
