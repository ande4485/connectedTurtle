import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

abstract class DeviceRepository {
  Future<void> updateDeviceSettings(Device device);

  Future<Device?> getDevice(String deviceId, DeviceType deviceType);

  Future<bool> deviceExist(String deviceId, DeviceType deviceType);

  Future<void> deleteDevice(String idDevice, DeviceType deviceType);

  Future<List<Device>> getDevicesByUser(idUser, deviceType);

  Future<Device?> getDeviceSettings(String idDevice, DeviceType deviceType);

  Future<Device> createDevice(ConfigDevices configDevices, String idBox);
}
