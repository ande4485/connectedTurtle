import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/message.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../generated/l10n.dart';
import '../../widget/dialog.dart';
import '../../widget/input_text.dart';

class VideoMessageCreationScreen extends StatefulWidget {
  final String textInput;
  const VideoMessageCreationScreen({super.key, required this.textInput});

  @override
  State createState() => VideoMessageCreationScreenState();
}

class VideoMessageCreationScreenState
    extends State<VideoMessageCreationScreen> {
  VideoPlayerController? _controller;
  final TextEditingController textEditingController = TextEditingController();
  Uint8List? _videoList;
  File? _videos;
  @override
  void initState() {
    getVideo(context);
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) _controller!.dispose();
    super.dispose();
  }

  Future getVideo(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false, withData: kIsWeb, type: FileType.video);
      if (result != null) {
        if (kIsWeb) {
          /**var bytesVideo = result.files.first.bytes;
          final blob = html.Blob(bytesVideo!);
          final url = html.Url.createObjectUrlFromBlob(blob);
          _controller = VideoPlayerController.network(url);
          _videoList = bytesVideo;**/
        } else {
          var file = File(result.files.first.path!);
          _controller = VideoPlayerController.file(file);
          await _controller!.initialize();
          _videos = file;
          setState(() {});
        }
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.current.error_during_selection),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        continueCallBack() async {
          context.pop(context);
          context.pop(context);
        }

        DialogWarning alert = DialogWarning(
            title: S.current.warning,
            content: S.current.warning_quit,
            continueCallBack: continueCallBack);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        return false;
      },
      child: Column(children: <Widget>[
        // List of messages
        Expanded(child: _controller != null ? buildVideos() : const SizedBox()),
        /**_controller != null
            ? Align(
                alignment: Alignment.center,
                child: buildPlay(),
              )
            : const SizedBox(),**/

        InputText(
            initialValue: widget.textInput,
            isFamily: true,
            needVocalAnswer: true,
            onPressedFunction: (content, isFamily, needVocalAnswer) {
              if (content.trim().isNotEmpty) {
                var message = VideoMessage(
                  date: DateTime.now(),
                  message: content,
                  link: [],
                  isFamily: isFamily,
                  needVocalAnswer: needVocalAnswer,
                  fromId: '',
                  fromStr: '',
                  id: '',
                  read: false,
                  to: '',
                );
                if (!kIsWeb) {
                  BlocProvider.of<PhoneMessageBloc>(context)
                      .sendMessageWithFiles(message, [_videos!]);
                } else {
                  BlocProvider.of<PhoneMessageBloc>(context)
                      .sendMessageWithDatas(message, [_videoList!]);
                }
                context.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(S.current.nothing_to_send),
                  duration: const Duration(seconds: 1),
                ));
              }
            })
      ]),

      // Input content
    );
  }

  Widget buildVideos() {
    return Stack(children: [
      VideoPlayer(_controller!),
      IconButton(
        icon: const Icon(Icons.play_circle),
        onPressed: () => _controller!.play(),
      )
    ]);
  }
}
