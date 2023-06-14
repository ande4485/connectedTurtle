import 'package:turtle_package/model/device_user.dart';

var admin = DeviceUser(
    id: '444',
    name: 'testName',
    lastName: 'lastName',
    turtlesInfo: [
      UserTurtleInfo(
          nameUserForDevice: "testName",
          idTurle: '0',
          nameTurtle: "testTurtle",
          userRole: [UserRole.admin])
    ],
    birthDate: DateTime.now());
