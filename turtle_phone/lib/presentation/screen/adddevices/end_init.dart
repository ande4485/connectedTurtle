import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:turtle_package/model/device.dart';

import '../../../generated/l10n.dart';
import '../design/color.dart';

class EndInitScreen extends StatelessWidget {
  final DeviceType deviceType;

  const EndInitScreen({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 400,
                    child: RiveAnimation.asset(
                      'assets/anim/turtle.riv',
                    )),
                Text(S.current.install_ok,
                    style: Theme.of(context).primaryTextTheme.headlineSmall!),
                deviceType == DeviceType.turtle
                    ? Container()
                    : Text(S.current.finish_setup_admin,
                        style:
                            Theme.of(context).primaryTextTheme.headlineSmall!)
              ],
            )));
  }
}
