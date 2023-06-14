import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

abstract class PhoneDeviceCommunication {
  Future<void> dispose();

  Future<bool> findDevice(DeviceType deviceType);

  Future<bool> testWifiDevice(ConfigDevices configDevice);

  Future<void> setConfig(ConfigDevices configDevice);
}
