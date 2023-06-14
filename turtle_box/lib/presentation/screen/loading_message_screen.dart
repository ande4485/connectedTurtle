import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_message_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_message_state.dart';
import 'package:turtle_box/presentation/screen/show_choices_screen.dart';
import 'package:turtle_box/presentation/screen/wrap_text_widget.dart';
import 'package:turtle_package/model/device.dart';

import 'design/constant.dart';
import 'diapo_screen.dart';
import 'end_screen.dart';
import 'loading.dart';

class LoadingMessageScreen extends StatelessWidget {
  final int typeDiapo;
  final Turtle currentDevice;

  const LoadingMessageScreen({super.key, required this.typeDiapo, required this.currentDevice});

  @override
  Widget build(BuildContext context) {
    BoxMessageBloc messageBloc = BlocProvider.of<BoxMessageBloc>(context);

    switch (typeDiapo) {
      // normal messages(=> new messages)
      case NEW_MESSAGE:
        {
          messageBloc.getNewMessages(currentDevice.id);
          break;
        }
      //diapo randomly messages
      case RANDOM_MESSAGE:
        {
          messageBloc.getLastMessages(currentDevice.id);
          break;
        }
      // family messages
      case FAMILY_MESSAGE:
        {
          messageBloc.getFamilyMessages(currentDevice.id);
          break;
        }
    }
    return Scaffold(
        body: BlocConsumer<BoxMessageBloc, BoxMessageState>(
            builder: (context, state) {
      if (state is MessageList) {
        if (state.messages.isEmpty) {
          return WrapTextWidget(
            message: S.current.no_message,
            fontSize: currentDevice.fontSize.toDouble(),
          );
        } else {
          return const SizedBox();
        }
      } else {
        return const Loading();
      }
    }, listener: (context, state) {
      if (state is MessageList) {
        if (state.messages.isNotEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DiapoPage(
                      messages: state.messages,
                      currentDevice: currentDevice,
                      modeNewMessages: typeDiapo == NEW_MESSAGE)));
        } else {
          //so there's no new message may be there's a problem
          //but we go at end
          if (typeDiapo == NEW_MESSAGE) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EndPage(currentDevice: currentDevice)));
          } else {
            Future.delayed(const Duration(seconds: 5)).then((onValue) =>
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowChoiceScreen(currentDevice: currentDevice))));
          }
        }
      }
    }));
  }
}
