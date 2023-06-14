enum UserRole {
  admin,
  box,
  normal,
  acceptInvit,
  invited,
  refuseInvit,
  emergency,
  owner
}

class DeviceUser {
  String id;

  String name;

  String lastName;

  DateTime birthDate;

  List<UserTurtleInfo> turtlesInfo;

  DeviceUser(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.turtlesInfo,
      //required this.simpleDevices,
      required this.birthDate});

  factory DeviceUser.empty(String id) {
    return DeviceUser(
        id: id,
        name: "",
        turtlesInfo: [],
        lastName: "",
        birthDate: DateTime.now());
  }
}

class SimpleDeviceUser {
  final String id;
  final String name;

  SimpleDeviceUser({required this.id, required this.name});
}

class UserTurtleInfo {
  final String nameUserForDevice;
  final List<UserRole> userRole;
  final String idTurle;
  final String nameTurtle;
  UserTurtleInfo(
      {required this.nameUserForDevice,
      required this.userRole,
      required this.idTurle,
      required this.nameTurtle});
}
