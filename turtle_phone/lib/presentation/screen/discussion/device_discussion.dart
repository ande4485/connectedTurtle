import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turtle_package/model/message.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';
import 'package:turtle_package/presentation/widget/video_widget.dart';
import 'package:turtle_phone/di/phone_di.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../generated/l10n.dart';
import '../../bloc/phone_message_bloc.dart';
import '../../bloc/phone_message_state.dart';
import '../custom_icons.dart';
import '../design/style.dart';
import '../messages/view/image_message_view.dart';
import '../messages/view/sound_message_view.dart';
import '../messages/view/youtube_message_view.dart';
import '../widget/input_text.dart';
import '../widget/loading.dart';
import '../widget/turtle_error.dart';
import 'bottom_message_selector.dart';

class DeviceDiscussionScreen extends StatefulWidget {
  const DeviceDiscussionScreen({super.key});

  @override
  State createState() => DeviceDiscussionScreenState();
}

class DeviceDiscussionScreenState extends State<DeviceDiscussionScreen> {
  List<Message> listMessage = List.empty(growable: true);
  bool isLoading = false;
  String imageUrl = "";
  final List<YoutubePlayerController> _controllers =
      List<YoutubePlayerController>.empty(growable: true);
  final List<VideoPlayerController> _videoControllers =
      List<VideoPlayerController>.empty(growable: true);
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  late PhoneMessageBloc _phoneMessageBloc;

  _scrollListener() {
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      _phoneMessageBloc.getMoreMessages();
    }
  }

  @override
  void initState() {
    super.initState();

    listScrollController.addListener(_scrollListener);
    isLoading = false;
    imageUrl = '';
    _phoneMessageBloc = BlocProvider.of<PhoneMessageBloc>(context)
      ..getMessages();
  }

  Future<void> onSendMessage(Message message) async {
    setState(() {
      isLoading = true;
    });

    await _phoneMessageBloc.sendMessage(message);
    setState(() {
      isLoading = false;
    });
    if (listScrollController.hasClients) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  VideoPlayerController getVideoController(String videoPath) {
    VideoPlayerController videoCtrl = VideoPlayerController.network(videoPath);

    _videoControllers.add(videoCtrl);
    return videoCtrl;
  }

  listener(YoutubePlayerController ctrl) {}

  Widget buildItem(int index, Message message, String userId) {
    bool right = message.fromId == userId;
    bool isLastElt = false;
    if (right) {
      isLastElt = isLastMessageRight(index, userId);
    } else {
      isLastElt = isLastMessageLeft(index, userId);
    }
    return Row(
        key: ObjectKey(message),
        mainAxisAlignment:
            right ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            margin:
                EdgeInsets.only(bottom: isLastElt ? 20.0 : 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                right
                    ? Text(
                        S.current.you,
                      )
                    : Text(
                        message.fromStr,
                      ),
                spaceBetweenField,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getWidgetForMessage(message),
                ),
                spaceBetweenField,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getDateTime(message.date),
                      style: const TextStyle(
                        fontSize: 9.0,
                      ),
                    ),
                    message is MessageWithText
                        ? const Spacer()
                        : const SizedBox(),
                    message is MessageWithText
                        ? Icon(
                            MyFlutterApp.turtle_on_2,
                            size: 20,
                            color: message.read == true
                                ? Colors.green
                                : Colors.grey,
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          )
        ]);
  }

  String getDateTime(DateTime dateTime) {
    return DateFormat.yMd().add_Hm().format(dateTime);
  }

  List<Widget> getWidgetForMessage(Message message) {
    // Text
    List<Widget> fields = List.empty(growable: true);
    if (message.type == MessageType.image) {
      // Image
      fields.add(
        ImageMessageView(
            photos: (message as ImageMessage).link, message: message.message),
      );
    } else if (message.type == MessageType.video) {
      fields.add(BlocProvider(
          create: (context) =>
              iD<DownloadBloc>(param1: (message as VideoMessage).link[0]),
          child: VideoWidget(
            autoRun: false,
            errorWidget: const Icon(Icons.remove),
            waitingWidget: const CircularProgressIndicator(),
          )));
    } else if (message.type == MessageType.youtubeVideo) {
      fields
          .add(YoutubeMessageView(idYoutube: (message as YoutubeMessage).link));
    } else if (message.type == MessageType.vocal) {
      fields.add(BlocProvider(
          create: (context) =>
              iD<DownloadBloc>(param1: (message as VocalMessage).link[0]),
          child: const SoundMessageView()));
    } else if (message.type == MessageType.emergency) {
      fields.add(Container(
          color: Colors.red,
          child: Text(
            (message as EmergencyMessage).message,
            style: const TextStyle(color: Colors.white),
          )));
      return fields;
    }
    fields.add(spaceBetweenField);
    if (message is MessageWithText) {
      fields.add(Text(
        message.message,
      ));
    }
    return fields;
  }

  bool isLastMessageLeft(int index, String userId) {
    if ((index > 0 && listMessage[index - 1].fromId != userId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index, String userId) {
    if ((index > 0 && listMessage[index - 1].fromId == userId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    context.pop(context);

    return Future.value(false);
  }

  @override
  void dispose() {
    _phoneMessageBloc.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              Expanded(child: buildListMessage()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Align(
        alignment: Alignment.bottomCenter,

        //widthFactor: 0,
        //width: double.infinity,
        //height: 50.0,

        child: InputText(
            isFamily: false,
            needVocalAnswer: true,
            attachFileWidget: BlocProvider(
                create: (_) => _phoneMessageBloc,
                child: BottomMessageSelector(
                    textInput: textEditingController.text)),
            onPressedFunction: (content, isFamily, needVocalAnswer) {
              if (content.trim().isNotEmpty) {
                var message = TextMessage(
                    id: "",
                    date: DateTime.now(),
                    message: content,
                    needVocalAnswer: needVocalAnswer,
                    fromId: '',
                    fromStr: '',
                    to: '');
                onSendMessage(message);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(S.current.nothing_to_send),
                  duration: const Duration(seconds: 1),
                ));
              }
            }));
  }

  Widget buildListMessage() {
    return BlocBuilder<PhoneMessageBloc, PhoneMessageState>(
        buildWhen: (context, state) {
      return state is MessageList;
    }, builder: (context, state) {
      if (state is MessageList) {
        isLoading = false;
        listMessage.addAll(state.messages);

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, index) =>
              buildItem(index, state.messages[index], state.userId),
          itemCount: state.messages.length,
          controller: listScrollController,
        );
      } else if (state is MessageLoad) {
        return const Loading();
      } else {
        return const TurtleError();
      }
    });
  }
}
