import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../design/color.dart';

class YoutubeMessageView extends StatefulWidget {
  final String idYoutube;

  const YoutubeMessageView({super.key, required this.idYoutube});

  @override
  State<StatefulWidget> createState() => YoutubeMessageViewState();
}

class YoutubeMessageViewState extends State<YoutubeMessageView> {
  @override
  void initState() {
    //String? videoId = YoutubePlayer.convertUrlToId(widget.urlYoutube);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: YoutubePlayer(
        controlsTimeOut: const Duration(seconds: 0),
        controller: YoutubePlayerController(
          initialVideoId: widget.idYoutube,
          flags: const YoutubePlayerFlags(
            controlsVisibleAtStart: false,
            hideControls: true,
            enableCaption: false,
            hideThumbnail: true,
            autoPlay: false,
          ),
        ),
        showVideoProgressIndicator: false,
      ),
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                YoutubeMessageViewFullScreen(idYoutube: widget.idYoutube)))
      },
    );
  }
}

class YoutubeMessageViewFullScreen extends StatelessWidget {
  final String idYoutube;

  const YoutubeMessageViewFullScreen({super.key, required this.idYoutube});

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: YoutubePlayerController(
              initialVideoId: idYoutube,
              flags: const YoutubePlayerFlags(
                  autoPlay: true, controlsVisibleAtStart: true)),
          showVideoProgressIndicator: true,
          onReady: () {},
        ),
        builder: (context, player) {
          return Material(
              child: Column(
            children: [
              IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close)),
              player,
            ],
          )
              // some widgets

              //some other widgets
              );
        });
  }
}
