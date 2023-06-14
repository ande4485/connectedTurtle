import 'package:flutter/material.dart';
import 'package:turtle_package/model/device.dart';

import '../../../generated/l10n.dart';
import '../design/color.dart';

//////////////////////////////ERROR THING ////////////////////////////////////////

class DevicesNotFound extends StatelessWidget {
  final DeviceType deviceType;

  const DevicesNotFound({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  S.current.no_device_found(deviceType == DeviceType.emergency
                      ? "emergency"
                      : "turtle"),
                  style: Theme.of(context).primaryTextTheme.titleLarge!),
              const SizedBox(height: 20),
              Text(
                  S.current.please_check_device(
                      deviceType == DeviceType.emergency
                          ? "emergency"
                          : "turtle"),
                  style: Theme.of(context).primaryTextTheme.titleLarge!),
            ],
          )),
    );
  }
}
