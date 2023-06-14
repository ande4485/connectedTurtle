import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/vocal_recorder.dart';
import 'package:turtle_box/presentation/screen/wrap_text_widget.dart';
import 'package:turtle_package/model/device.dart';

import 'design/constant.dart';
import 'end_screen.dart';
import 'loading_message_screen.dart';

class ShowChoiceScreen extends StatelessWidget {
  final Turtle currentDevice;

  const ShowChoiceScreen({super.key, required this.currentDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowChoices(currentDevice: currentDevice),
    );
  }
}

class ShowChoices extends StatefulWidget {
  final Turtle currentDevice;

  const ShowChoices({super.key, required this.currentDevice});

  @override
  ShowChoicesState createState() => ShowChoicesState();
}

class ShowChoicesState extends State<ShowChoices> {
  List<String> listOfChoices = [
    S.current.see_last_messages,
    S.current.see_photos_videos_family,
    S.current.let_vocal_message,
    S.current.exit
  ];
  late List<String> listToDisplay;

  bool _showChoice = true;

  void _selectUser(String choice) async {
    print("show choice user $choice");
    var userSelected =
        widget.currentDevice.users.firstWhere((user) => user.name == choice);
    var idUserSelected = userSelected.id;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => VocalRecorderPage(
                  toId: idUserSelected,
                  currentDevice: widget.currentDevice,
                  answerForMessage: false,
                )));
  }

  void _selectChoice(String choice) async {
    print("show choice  $choice");
    if (choice == S.current.see_last_messages) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoadingMessageScreen(
                    typeDiapo: 1,
                    currentDevice: widget.currentDevice,
                  )));

      //may be it's empty so come back
    } else if (choice == S.current.see_photos_videos_family) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoadingMessageScreen(
                    typeDiapo: 2,
                    currentDevice: widget.currentDevice,
                  )));
      //may be it's empty so come back
    } else if (choice == S.current.exit) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EndPage(currentDevice: widget.currentDevice)));
    } else {
      //show potential users for vocal message
      setState(() {
        listToDisplay = widget.currentDevice.users.map((e) => e.name).toList();
        _showChoice = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.currentDevice.users.isEmpty) {
      listOfChoices.remove(S.current.let_vocal_message);
    }
    listToDisplay = listOfChoices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _showChoice
        ? Carrousel(
            title: S.current.press_turtle_select_choice,
            currentDevice: widget.currentDevice,
            onTapItem: _selectChoice,
            valuesToDisplay: listToDisplay,
          )
        : Carrousel(
            title: S.current.press_turtle_select_user,
            currentDevice: widget.currentDevice,
            onTapItem: _selectUser,
            valuesToDisplay: listToDisplay,
          );
  }
}

class Carrousel extends StatefulWidget {
  final List<String> valuesToDisplay;
  final Function(String) onTapItem;
  final Turtle currentDevice;
  final String title;
  const Carrousel(
      {super.key,
      required this.valuesToDisplay,
      required this.onTapItem,
      required this.currentDevice,
      required this.title});

  @override
  State<StatefulWidget> createState() => CarrouselState();
}

class CarrouselState extends State<Carrousel> {
  late Timer timer;
  var listChoicesPtr = 0;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    timer = Timer.periodic(
        showChoiceDuration,
        (Timer t) => setState(() {
              if (listChoicesPtr + 1 == widget.valuesToDisplay.length) {
                listChoicesPtr = 0;
              } else {
                listChoicesPtr++;
              }
            }));
  }

  @override
  void didUpdateWidget(covariant Carrousel oldWidget) {
    timer.cancel();
    listChoicesPtr = 0;
    startTimer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(
        builder: (context, state) {
          print("show choices ${widget.valuesToDisplay[listChoicesPtr]}");
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      fontSize: widget.currentDevice.fontSize.toDouble()),
                  maxLines: 2),
              Expanded(
                  child: WrapTextWidget(
                      message: widget.valuesToDisplay[listChoicesPtr],
                      fontSize: widget.currentDevice.fontSize.toDouble())),
            ],
          );
        },
        listenWhen: (oldState, newState) =>
            newState is BoxEventNext ||
            newState is BoxTimeOut ||
            newState is BoxTimeOutStop ||
            newState is BoxStart,
        listener: (context, state) {
          print("state choice $state");
          if (state is BoxEventNext) {
            timer.cancel();
            widget.onTapItem(widget.valuesToDisplay[listChoicesPtr]);
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
