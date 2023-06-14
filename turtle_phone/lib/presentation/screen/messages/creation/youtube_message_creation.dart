import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/message.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../generated/l10n.dart';
import '../../design/color.dart';
import '../../widget/input_text.dart';

class YoutubeMessageCreationScreen extends StatefulWidget {
  final String textInput;
  const YoutubeMessageCreationScreen({super.key, required this.textInput});

  @override
  State createState() => YoutubeSelectionState();
}

class YoutubeSelectionState extends State<YoutubeMessageCreationScreen> {
  String youtubeUrl = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController youtubeEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /** showDialog(
            context: context,
            builder: (context) => AlertDialog(
            title: Text('Are you sure you want to quit?'),
            actions: <Widget>[
            RaisedButton(
            child: Text('yes'),
            onPressed: () => Navigator.of(context).pop(true)),
            RaisedButton(
            child: Text('cancel'),
            onPressed: () => Navigator.of(context).pop(false)),
            ]));**/
        context.pop();
        return false;
      },
      child: Stack(
        children: <Widget>[
          Column(children: [
            Expanded(
                child: youtubeUrl.isNotEmpty
                    ? buildYoutubeView(youtubeUrl)
                    : const SizedBox()),

            // List of messages

            Align(
              alignment: Alignment.bottomCenter,
              child: InputText(
                  needVocalAnswer: true,
                  isFamily: false,
                  onPressedFunction: (content, isFamily, needVocalAnswer) {
                    if (content.trim().isNotEmpty &&
                        youtubeUrl.trim().isNotEmpty) {
                      var youtubeId = YoutubePlayer.convertUrlToId(youtubeUrl);
                      if (youtubeId != null) {
                        var message = YoutubeMessage(
                          date: DateTime.now(),
                          message: content,
                          link: youtubeId,
                          needVocalAnswer: needVocalAnswer,
                          read: false,
                          fromId: '',
                          fromStr: '',
                          id: '',
                          to: '',
                        );
                        BlocProvider.of<PhoneMessageBloc>(context)
                            .sendMessage(message);
                      }

                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Nothing to send'),
                        duration: Duration(seconds: 1),
                      ));
                    }
                  }),
            ),
          ]),
          Align(alignment: Alignment.topLeft, child: buildYoutubeText()),
          //buildYoutubeView(),

          // Input content
        ],
      ),
    );
  }

  YoutubePlayerController getYoutubeController(String youtubeUrl) {
    YoutubePlayerController ctrl;
    String? videoId = YoutubePlayer.convertUrlToId(youtubeUrl);

    ctrl = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));

    return ctrl;
  }

  Widget buildYoutubeView(String youtubeUrl) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: YoutubePlayer(
          key: Key(youtubeUrl),
          controller: getYoutubeController(youtubeUrl),
          showVideoProgressIndicator: true,
          onReady: () {},
        ));
  }

  Widget buildYoutubeText() {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                // Button send image
                // Edit text
                Flexible(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 2,
                      onSaved: (String? value) {
                        if (value != null) {
                          String? videoId = YoutubePlayer.convertUrlToId(value);
                          if (videoId != null) {
                            setState(() {
                              youtubeUrl = value;
                            });
                          }
                        }
                      },
                      validator: (value) {
                        if (value != null &&
                            (value.isEmpty ||
                                YoutubePlayer.convertUrlToId(value) == null)) {
                          return S.of(context).please_enter_valid_youtube;
                        }
                        return null;
                      },
                      controller: youtubeEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: S.of(context).url_youtube,
                        hintStyle: const TextStyle(color: grey_color),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.highlight_off),
                  onPressed: () {
                    youtubeEditingController.clear();
                  },
                ),

                // Button send message
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
