import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/message/message_widget.dart';
import 'package:turtle_package/model/message.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../main.dart';

class YoutubeMessagePage extends StatelessWidget {
  final YoutubeMessage message;
  final int fontSize;

  const YoutubeMessagePage(
      {super.key, required this.message, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubeMessageScreen(message: message, fontSize: fontSize),
    );
  }
}

class YoutubeMessageScreen extends StatefulWidget {
  final YoutubeMessage message;
  final int fontSize;

  const YoutubeMessageScreen(
      {super.key, required this.message, required this.fontSize});

  @override
  YoutubeMessageScreenState createState() => YoutubeMessageScreenState();
}

class YoutubeMessageScreenState extends State<YoutubeMessageScreen> {
  var readVideo = false;
  bool showVideo = false;

  YoutubePlayerController getYoutubeController(String youTubeId) {
    YoutubePlayerController ctrl = YoutubePlayerController(
        initialVideoId: youTubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ));

    return ctrl;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(
        buildWhen: (oldState, newState) => newState is BoxEventNext,
        builder: (context, state) {
          if (!showVideo) {
            showVideo = true;
            return MessageWidget(
                messageFrom: widget.message.fromStr,
                message: widget.message.message,
                fontSize: widget.fontSize.toDouble());
          } else {
            readVideo = true;

            return Center(
                child: YoutubePlayer(
              controller: getYoutubeController(widget.message.link),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Theme.of(context).primaryColor,
              onReady: () {},
              onEnded: (youtubeMetaData) {
                Navigator.of(context).pop();
              },
            ));
          }
        },
        listenWhen: (oldState, newState) =>
            newState is BoxEventNext ||
            newState is BoxTimeOut ||
            newState is BoxTimeOutStop ||
            newState is BoxStart,
        listener: (context, state) {
          if (state is BoxEventNext) {
            if (readVideo) {
              Navigator.of(context).pop();
            }
          } else if (state is BoxTimeOut) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(S.current.press_turtle, key: const Key("timeout"))));
          } else if (state is BoxTimeOutStop) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          } else if (state is BoxStart) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomePage()));
          }
        });
  }
}
