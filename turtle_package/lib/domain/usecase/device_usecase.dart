import 'package:turtle_package/domain/repository/device_repository.dart';

import 'package:turtle_package/model/device.dart';

class DeviceUseCase {
  final DeviceRepository repository;

  DeviceUseCase({required this.repository});

  Future<void> updateDeviceSettings(Device device) {
    return repository.updateDeviceSettings(device);
  }

  Future<void> deleteDevice(String idDevice, DeviceType deviceType) {
    return repository.deleteDevice(idDevice, deviceType);
  }

  Future<List<Device>> getDevicesByUser(idUser, deviceType) {
    return repository.getDevicesByUser(idUser, deviceType);
  }

  Future<Device?> getDeviceSettings(String idDevice, DeviceType deviceType) {
    return repository.getDeviceSettings(idDevice, deviceType);
  }
}
