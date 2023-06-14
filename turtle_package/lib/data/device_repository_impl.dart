import 'package:turtle_package/data/remote/remote_device_datasource.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';

import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

class DeviceRepositoryImpl extends DeviceRepository {
  final RemoteDeviceDataSource remoteDeviceDataSource;

  DeviceRepositoryImpl({required this.remoteDeviceDataSource});

  @override
  Future<Device?> getDeviceSettings(idDevice, DeviceType deviceType) {
    return remoteDeviceDataSource.getDeviceSettings(idDevice, deviceType);
  }

  @override
  Future<void> updateDeviceSettings(Device device) {
    return remoteDeviceDataSource.updateDeviceSettings(device);
  }

  @override
  Future<void> deleteDevice(String idDevice, DeviceType deviceType) {
    return remoteDeviceDataSource.deleteDevice(idDevice, deviceType);
  }

  Future<Device> createDevice(ConfigDevices configDevices, idBox) {
    return remoteDeviceDataSource.createDevice(configDevices, idBox);
  }

  @override
  Future<List<Device>> getDevicesByUser(idUser, deviceType) {
    return remoteDeviceDataSource.getDevicesByUser(idUser, deviceType);
  }

  @override
  Future<bool> deviceExist(String deviceId, DeviceType deviceType) {
    return remoteDeviceDataSource.deviceExist(deviceId, deviceType);
  }

  @override
  Future<Device?> getDevice(String deviceId, DeviceType deviceType) {
    return remoteDeviceDataSource.getDevice(deviceId, deviceType);
  }
}
