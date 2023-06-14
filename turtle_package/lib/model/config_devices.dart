import 'package:turtle_package/model/device.dart';

abstract class ConfigDevices {
  String ipBox;
  String ssid;
  String passwd;
  DeviceType type;
  String userId;
  String userName;

  ConfigDevices(
      {required this.type,
      required this.ipBox,
      required this.passwd,
      required this.ssid,
      required this.userId,
      required this.userName});

  forJson();
}

class ConfigTurtle extends ConfigDevices {
  String nameForTurtle;
  String idTurtle;

  ConfigTurtle({
    required super.ipBox,
    required super.passwd,
    required super.ssid,
    required super.userId,
    required super.userName,
    required this.idTurtle,
    required this.nameForTurtle,
  }) : super(type: DeviceType.turtle);

  factory ConfigTurtle.empty() {
    return ConfigTurtle(
      ipBox: "",
      passwd: "",
      ssid: "",
      userId: "",
      userName: "",
      idTurtle: "",
      nameForTurtle: "",
    );
  }

  forJson() {
    return {'ssid': ssid, 'pswd': passwd, 'ipBox': ipBox, 'id': idTurtle};
  }
}

class ConfigEmergency extends ConfigDevices {
  String message;
  String turtleId;
  ConfigEmergency({
    required super.ipBox,
    required super.passwd,
    required super.ssid,
    required super.userId,
    required super.userName,
    required this.turtleId,
    required this.message,
  }) : super(type: DeviceType.emergency);

  factory ConfigEmergency.empty() {
    return ConfigEmergency(
        ipBox: "",
        passwd: "",
        ssid: "",
        userId: "",
        userName: "",
        message: "",
        turtleId: "");
  }

  @override
  forJson() {
    return {'ssid': ssid, 'pswd': passwd, 'ipBox': ipBox, 'mess': message};
  }
}
