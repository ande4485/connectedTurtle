import 'package:flutter/material.dart';

import '../custom_icons.dart';
import '../design/color.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // late Animation _colorTween;
  late TweenSequence colorTurtle;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorTurtle = TweenSequence([
      TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: grey_color,
            end: Theme.of(context).colorScheme.onPrimary,
          )),
    ]);
    return AnimatedBuilder(
        animation: _controller,
        builder: (buildContext, widget) {
          return Center(
              child: Icon(
            MyFlutterApp.turtle_on_2,
            size: 70,
            color:
                colorTurtle.evaluate(AlwaysStoppedAnimation(_controller.value)),
          ));
        });
  }
}
