import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../custom_icons.dart';

class TurtleError extends StatelessWidget {
  const TurtleError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MyFlutterApp.turtle_on_2,
            size: 70, color: Theme.of(context).colorScheme.error),
        Text(S.current.oops_error)
      ],
    );
  }
}
