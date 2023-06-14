import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/main.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/wrap_text_widget.dart';
import 'package:turtle_package/model/device.dart';

import 'design/constant.dart';

class EndPage extends StatelessWidget {
  final Turtle currentDevice;

  const EndPage({super.key, required this.currentDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EndScreen(currentDevice: currentDevice),
    );
  }
}

class EndScreen extends StatefulWidget {
  final Turtle currentDevice;

  const EndScreen({super.key, required this.currentDevice});

  @override
  EndScreenState createState() => EndScreenState();
}

class EndScreenState extends State<EndScreen> {
  late BoxBloc _boxBloc;
  late Timer _timer;
  int _counter = TIME_BEFORE_END;

  @override
  void initState() {
    super.initState();
    _boxBloc = BlocProvider.of<BoxBloc>(context);
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_counter == 0) {
          _boxBloc.restart();
          timer.cancel();
        } else {
          setState(() {
            _counter--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(builder: (context, state) {
      return Column(children: [
        Text(S.current.end_message(_counter.toString()),
            key: const Key("goodByeText"),
            style:
                TextStyle(fontSize: widget.currentDevice.fontSize.toDouble()),
            maxLines: 2),
        widget.currentDevice.messageBeforeEnd != null &&
                widget.currentDevice.messageBeforeEnd!.isNotEmpty
            ? Expanded(
                child: WrapTextWidget(
                    message: widget.currentDevice.messageBeforeEnd!,
                    fontSize: widget.currentDevice.fontSize.toDouble()))
            : const SizedBox()
      ]);
    }, listener: (context, state) {
      if (state is BoxStart) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()));
      }
    });
  }
}
