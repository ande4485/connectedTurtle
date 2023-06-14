import 'package:turtle_package/model/device_user.dart';

abstract class DeviceUsersRepository {
  Future<void> changeAdmin(idUser, idDevice);

  Future<void> createInvitation(
      String email, String idDevice, String nameForDevice);

  Future<void> removeUserOfDevice(DeviceUser turtleUser, String idDevice);

  Future<void> addUserToEmergency(DeviceUser turtleUser, String idDevice);

  Future<void> removeUserEmergency(DeviceUser turtleUser, String idDevice);

  Stream<(List<DeviceUser>, List<DeviceUser>, List<DeviceUser>)> getDeviceUsers(
      String idDevice);

  Future<DeviceUser> getUser(String idUser);

  Future<void> acceptInvitation(
      String idUser, Map<String, dynamic> invitationParams);

  Future<DeviceUser> updateUser(DeviceUser userDevice);

  Future<void> refuseInvitation(idUser, idDevice);
}
