import 'package:turtle_package/domain/repository/device_user_repository.dart';

import 'package:turtle_package/model/device_user.dart';

class DeviceUsersUseCase {
  final DeviceUsersRepository repository;

  DeviceUsersUseCase({required this.repository});

  Future<void> changeAdmin(idUser, idTurtle) {
    return repository.changeAdmin(idUser, idTurtle);
  }

  Future<void> createInvitation(
      String email, String idDevice, String nameTurtle) {
    return repository.createInvitation(email, idDevice, nameTurtle);
  }

  Future<void> removeUserOfDevice(DeviceUser deviceUser, String idDevice) {
    return repository.removeUserOfDevice(deviceUser, idDevice);
  }

  Future<void> addUserToEmergency(DeviceUser deviceUser, String idDevice) {
    return repository.addUserToEmergency(deviceUser, idDevice);
  }

  Future<void> removeUserEmergency(DeviceUser deviceUser, String idDevice) {
    return repository.removeUserEmergency(deviceUser, idDevice);
  }

  Stream<(List<DeviceUser>, List<DeviceUser>, List<DeviceUser>)> getDeviceUsers(
      String idDevice) {
    return repository.getDeviceUsers(idDevice);
  }

  Future<DeviceUser> getUser(String idUser) {
    return repository.getUser(idUser);
  }

  Future<void> acceptInvitation(
      String idUser, Map<String, dynamic> invitationParams) {
    return repository.acceptInvitation(idUser, invitationParams);
  }

  Future<void> refuseInvitation(DeviceUser user, String idDevice) {
    return repository.refuseInvitation(user, idDevice);
  }

  Future<void> updateUser(DeviceUser user) {
    return repository.updateUser(user);
  }
}
