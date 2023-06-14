import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/device.dart';
import '../../../generated/l10n.dart';

class WarningInitMessage extends StatelessWidget {
  final DeviceType deviceType;

  const WarningInitMessage({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.current.verify_bluetooth,
                      style: Theme.of(context).primaryTextTheme.titleLarge!),
                  Text(
                      S.current.dont_switch_off(
                          deviceType == DeviceType.emergency
                              ? "Emergency"
                              : "Turtle"),
                      style: Theme.of(context).primaryTextTheme.titleLarge!),
                  Text(S.current.dont_switch_off_android_box,
                      style: Theme.of(context).primaryTextTheme.titleLarge!),
                  Text(S.current.app_android_box_running,
                      style: Theme.of(context).primaryTextTheme.titleLarge!),
                  Text(
                      S.current.same_wifi(deviceType == DeviceType.emergency
                          ? "Emergency"
                          : "Turtle"),
                      style: Theme.of(context).primaryTextTheme.titleLarge!),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton(
                      onPressed: () {
                        context
                            .pushReplacementNamed('adddevice', pathParameters: {
                          'devicetype': deviceType.name,
                        });
                      },
                      child: const Text('OK'),
                    ),
                  ])
                ])));
  }
}
