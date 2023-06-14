import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/design/constant.dart';
import 'package:turtle_package/model/message.dart';

import 'message_widget.dart';

///widget showing message text
class TextMessagePage extends StatelessWidget {
  final TextMessage message;
  final int fontSize;

  const TextMessagePage({super.key, required this.message, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextMessageScreen(message: message, fontSize: fontSize),
    );
  }
}

class TextMessageScreen extends StatefulWidget {
  final TextMessage message;
  final int fontSize;

  const TextMessageScreen({super.key, required this.message, required this.fontSize});

  @override
  TextMessageScreenState createState() => TextMessageScreenState();
}

class TextMessageScreenState extends State<TextMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(
        builder: (context, state) {
          return MessageWidget(messageFrom: widget.message.fromStr,message: widget.message.message,fontSize: widget.fontSize.toDouble());
        },
        listenWhen: (oldState, newState) =>
            newState is BoxEventNext ||
            newState is BoxTimeOut ||
            newState is BoxTimeOutStop ||
            newState is BoxStart,
        listener: (context, state) {
          if (state is BoxEventNext) {
            Navigator.of(context).pop(false);
          } else if (state is BoxTimeOut) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(S.current.press_turtle, key:const Key("timeout")),
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
