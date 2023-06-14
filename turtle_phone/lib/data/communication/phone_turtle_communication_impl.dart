import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

import '../../domain/communication/phone_turtle_com.dart';
import 'bluetooth/bluetooth_communication.dart';

class PhoneDeviceCommunicationImpl extends PhoneDeviceCommunication {
  final BluetoothCommunication bluetoothCommunication;

  PhoneDeviceCommunicationImpl({required this.bluetoothCommunication});

  @override
  Future<bool> findDevice(DeviceType deviceType) {
    return bluetoothCommunication.findDevice(deviceType, 10);
  }

  @override
  Future<void> setConfig(ConfigDevices configDevice) {
    return bluetoothCommunication.setConfig(configDevice);
  }

  @override
  Future<void> dispose() {
    return bluetoothCommunication.dispose();
  }

  @override
  Future<bool> testWifiDevice(ConfigDevices configDevice) {
    return bluetoothCommunication.testWifiDevice(configDevice);
  }
}
