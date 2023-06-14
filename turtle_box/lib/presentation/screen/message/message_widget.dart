import 'package:flutter/cupertino.dart';
import 'package:turtle_box/generated/l10n.dart';

import '../wrap_text_widget.dart';

class MessageWidget extends StatelessWidget{
  final String messageFrom;
  final String message;
  final double fontSize;
  const MessageWidget({super.key, required this.messageFrom, required this.message, required this.fontSize});


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.current.tells_you(messageFrom),
              style: TextStyle(fontSize: fontSize ),
              maxLines: 2,
            ),
            WrapTextWidget(
                message: message,
                fontSize: fontSize),
          ],
        ));
  }



}