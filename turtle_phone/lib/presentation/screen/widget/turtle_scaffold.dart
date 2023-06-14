import 'package:flutter/material.dart';

import '../design/color.dart';

class TurtleScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final FloatingActionButton? floatingActionButton;

  const TurtleScaffold(
      {super.key, required this.body, this.appBar, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButton,
        appBar: appBar,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Colors.green.shade100,
              ],
            ),
          ),
          child: Padding(padding: const EdgeInsets.all(15), child: body),
        ));
  }
}
