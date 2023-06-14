import 'package:turtle_package/data/remote/remote_device_users_datasource.dart';
import 'package:turtle_package/domain/repository/device_user_repository.dart';

import 'package:turtle_package/model/device_user.dart';

class DeviceUserRepositoryImpl extends DeviceUsersRepository {
  final RemoteDeviceUsersDataSource remoteDeviceUserDataSource;

  DeviceUserRepositoryImpl({required this.remoteDeviceUserDataSource});

  @override
  Future<void> changeAdmin(idUser, idDevice) {
    return remoteDeviceUserDataSource.changeAdmin(idUser, idDevice);
  }

  @override
  Future<void> createInvitation(
      String email, String idDevice, String nameForDevice) {
    return remoteDeviceUserDataSource.createInvitation(
        email, idDevice, nameForDevice);
  }

  @override
  Future<void> addUserToEmergency(DeviceUser turtleUser, String idDevice) {
    return remoteDeviceUserDataSource.addUserToEmergency(turtleUser, idDevice);
  }

  @override
  Future<void> removeUserOfDevice(DeviceUser turtleUser, String idDevice) {
    return remoteDeviceUserDataSource.removeUserOfDevice(turtleUser, idDevice);
  }

  @override
  Future<void> removeUserEmergency(DeviceUser turtleUser, String idDevice) {
    return remoteDeviceUserDataSource.removeUserEmergency(turtleUser, idDevice);
  }

  Stream<(List<DeviceUser>, List<DeviceUser>, List<DeviceUser>)> getDeviceUsers(
      String idDevice) {
    return remoteDeviceUserDataSource.getDeviceUsers(idDevice);
  }

  @override
  Future<void> acceptInvitation(
      String idUser, Map<String, dynamic> invitationParams) {
    return remoteDeviceUserDataSource.acceptInvitation(
        idUser, invitationParams);
  }

  @override
  Future<DeviceUser> getUser(String idUser) {
    return remoteDeviceUserDataSource.getUser(idUser);
  }

  @override
  Future<void> refuseInvitation(idUser, idDevice) {
    return remoteDeviceUserDataSource.refuseInvitation(idUser, idDevice);
  }

  @override
  Future<DeviceUser> updateUser(DeviceUser userDevice) {
    return remoteDeviceUserDataSource.updateUser(userDevice);
  }
}
