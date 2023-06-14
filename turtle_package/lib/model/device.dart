import 'package:turtle_package/model/device_user.dart';

class Device {
  final DeviceType deviceType;

  final String id;

  Device({
    required this.deviceType,
    required this.id,
  });
}

class Turtle extends Device {
  final nameDevice;

  int fontSize;

  bool showInfo;

  String? messageBeforeEnd;

  List<SimpleDeviceUser> users;

  Turtle({
    required String id,
    required this.nameDevice,
    required this.fontSize,
    required this.showInfo,
    this.messageBeforeEnd,
    required this.users,
  }) : super(id: id, deviceType: DeviceType.turtle);
}

class Emergency extends Device {
  final String turtleId;
  final String message;
  Emergency({
    required String id,
    required this.turtleId,
    required this.message,
  }) : super(id: id, deviceType: DeviceType.emergency);
}

enum DeviceType { camera_user, turtle, emergency }
