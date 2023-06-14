import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

abstract class RemoteDeviceDataSource {
  Future<void> updateDeviceSettings(Device device);

  Stream<Device?> listenDevice(idDevice);

  Future<Device?> getDeviceSettings(idDevice, DeviceType deviceType);

  Future<void> deleteDevice(String idDevice, DeviceType deviceType);

  Future<Device> createDevice(ConfigDevices configDevices, String idBox);

  Future<List<Device>> getDevicesByUser(idUser, deviceType);

  Future<bool> deviceExist(String deviceId, DeviceType deviceType);

  Future<Device?> getDevice(String deviceId, DeviceType deviceType);
}
