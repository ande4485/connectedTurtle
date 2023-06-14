import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/design/constant.dart';
import 'package:turtle_package/model/message.dart';

import 'message_widget.dart';

/// Widget to show image message
class ImageMessagePage extends StatelessWidget {
  final ImageMessage message;
  final int fontSize;

  const ImageMessagePage({super.key, required this.message, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageMessageScreen(message: message, fontSize: fontSize),
    );
  }
}

class ImageMessageScreen extends StatefulWidget {
  final ImageMessage message;
  final int fontSize;

  const ImageMessageScreen({super.key, required this.message, required this.fontSize});

  @override
  ImageMessageScreenState createState() => ImageMessageScreenState();
}

class ImageMessageScreenState extends State<ImageMessageScreen> {
  int indexLink = -1;
  bool showMessage = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoxBloc, BoxState>(
        buildWhen: (oldState, newState) => newState is BoxEventNext,
        builder: (context, state) {
          if (showMessage) {
            showMessage = false;
            return MessageWidget(messageFrom: widget.message.fromStr,message: widget.message.message,fontSize: widget.fontSize.toDouble());
          } else {
            indexLink++;
            if (indexLink >= widget.message.link.length) {
              return const SizedBox();
            } else {
              return Center(
                  child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  padding: const EdgeInsets.all(70.0),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Text(S.current.error_loading, key: const Key("ImageErrorText")),
                imageUrl: widget.message.link[indexLink],
                fit: BoxFit.fill,
              ));
            }
          }
        },
        listenWhen: (oldState, newState) =>
            newState is BoxEventNext ||
            newState is BoxTimeOut ||
            newState is BoxTimeOutStop ||
            newState is BoxStart,
        listener: (context, state) {
          if (state is BoxEventNext) {
            if (indexLink == widget.message.link.length - 1) {
              Navigator.of(context).pop(false);
            }
          } else if (state is BoxTimeOut) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(S.current.press_turtle),
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
