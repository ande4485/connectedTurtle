import 'package:turtle_package/model/device_user.dart';

abstract class RemoteDeviceUsersDataSource {
  Future<void> changeAdmin(idUser, idDevice);

  Future<void> createInvitation(
      String email, String idDevice, String nameForDevice);

  Future<void> removeUserOfDevice(DeviceUser turtleUser, String idDevice);

  Future<void> addUserToEmergency(DeviceUser turtleUser, String idDevice);

  Future<void> removeUserEmergency(DeviceUser turtleUser, String idDevice);

  Stream<(List<DeviceUser>, List<DeviceUser>, List<DeviceUser>)> getDeviceUsers(
      String idDevice);

  Future<DeviceUser> getUser(String userId);

  Future<void> acceptInvitation(
      String idUser, Map<String, dynamic> invitationParams);

  Future<DeviceUser> updateUser(DeviceUser user);

  Future<void> refuseInvitation(idUser, idDevice);
}
