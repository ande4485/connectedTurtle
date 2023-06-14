import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/di/box_di.dart';
import 'package:turtle_box/presentation/bloc/diapo_bloc.dart';
import 'package:turtle_box/presentation/bloc/diapo_state.dart';
import 'package:turtle_box/presentation/screen/vocal_recorder.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

import '../../main.dart';
import 'design/constant.dart';
import 'loading_message_screen.dart';
import 'message/image_message_screen.dart';
import 'message/text_message_screen.dart';
import 'message/video_message_screen.dart';
import 'message/youtube_message_screen.dart';

class DiapoPage extends StatelessWidget {
  final List<Message> messages;
  final Turtle currentDevice;
  final bool modeNewMessages;

  const DiapoPage(
      {super.key, required this.messages,
      required this.currentDevice,
      required this.modeNewMessages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<DiapoBloc>(
          create: (context) => DiapoBloc(
                messageRepository: iD(),
                idTurtle: currentDevice.id,
                newMessagesDiapo: modeNewMessages,
                messages: messages,
              ),
          child: DiapoScreen(messages: messages, currentDevice: currentDevice)),
    );
  }
}

class DiapoScreen extends StatefulWidget {
  final List<Message> messages;
  final Turtle currentDevice;

  const DiapoScreen({super.key, required this.messages, required this.currentDevice});

  @override
  DiapoScreenState createState() => DiapoScreenState();
}

class DiapoScreenState extends State<DiapoScreen> {
  StreamSubscription? listenerDiapoBloc;

  @override
  void initState() {
    DiapoBloc diapoBloc = BlocProvider.of<DiapoBloc>(context);
    //listening new diapo to show
    listenerDiapoBloc =
        BlocProvider.of<DiapoBloc>(context).stream.listen((state) async {
      print("diapo_state $state");
      bool timeout = false;
      if (state is DiapoShowText) {
        timeout = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TextMessagePage(
                    message: state.actualMessage,
                    fontSize: widget.currentDevice.fontSize)));
        if (!timeout) {
          diapoBloc.nextDiapo();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomePage()));
        }
      } else if (state is DiapoShowImage) {
        timeout = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageMessagePage(
                    message: state.actualMessage,
                    fontSize: widget.currentDevice.fontSize)));
        if (!timeout) {
          diapoBloc.nextDiapo();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomePage()));
        }
      } else if (state is DiapoShowVideo) {
        timeout = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoMessagePage(
                    message: state.actualMessage,
                    fontSize: widget.currentDevice.fontSize)));
        if (!timeout) {
          diapoBloc.nextDiapo();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomePage()));
        }
      } else if (state is DiapoShowYoutubeVideo) {
        timeout = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YoutubeMessagePage(
                    message: state.actualMessage,
                    fontSize: widget.currentDevice.fontSize)));
        if (!timeout) {
          diapoBloc.nextDiapo();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomePage()));
        }
      } else if (state is DiapoShowVocalRecorder) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VocalRecorderPage(
                      toId: state.actualMessage.fromId,
                      currentDevice: widget.currentDevice,
                      answerForMessage: true,
                    ))).whenComplete(() => diapoBloc.nextDiapo());
      } else if (state is DiapoEnd) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoadingMessageScreen(
                  typeDiapo: NEW_MESSAGE,
                  currentDevice: widget.currentDevice,
                )));
      }
    });
    //so show first diapo
    BlocProvider.of<DiapoBloc>(context).nextDiapo();
    super.initState();
  }

  @override
  void dispose() {
    if (listenerDiapoBloc != null) listenerDiapoBloc!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
