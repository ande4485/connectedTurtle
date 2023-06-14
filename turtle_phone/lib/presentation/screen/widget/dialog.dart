import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';

class DialogWarning extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback continueCallBack;

  const DialogWarning(
      {super.key,
      required this.title,
      required this.content,
      required this.continueCallBack});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            OutlinedButton(
              child: Text(S.current.ok),
              onPressed: () {
                continueCallBack();
              },
            ),
            OutlinedButton(
              child: Text(S.current.cancel),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ));
  }
}
