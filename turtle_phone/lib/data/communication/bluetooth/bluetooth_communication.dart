import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

class BluetoothCommunication {
  late FlutterBluePlus bleManager;
  static const UUID_TURTLE = "0d153e08-c941-11ea-87d0-0242ac130003";
  static const UUID_EMERGENCY = "0d153e08-c941-11ea-87d0-0242ac130004";
  BluetoothDevice? btDevice;

  BluetoothCommunication();

  Future<void> init() async {}

  Future<void> dispose() async {
    if (btDevice != null) {
      btDevice!.disconnect();
      btDevice = null;
    }
  }

  Future<bool> findDevice(DeviceType deviceType, int time) async {
    bool deviceFound = false;
    bleManager = FlutterBluePlus.instance;
    Guid deviceGuid;
    String deviceNameToFind;
    if (deviceType == DeviceType.turtle) {
      deviceGuid = Guid(UUID_TURTLE);
      deviceNameToFind = "Turtle";
    } else {
      deviceGuid = Guid(UUID_EMERGENCY);
      deviceNameToFind = "Turtle_EM";
    }
    await for (ScanResult scanResult in bleManager
        .scan(timeout: Duration(seconds: time), withServices: [deviceGuid])) {
      if (scanResult.device.name == deviceNameToFind) {
        btDevice = scanResult.device;
        deviceFound = true;
        bleManager.stopScan();
      }
    }
    return deviceFound;
  }

  Future<void> setConfig(ConfigDevices configDevice) async {
    await btDevice!.connect(autoConnect: false);
    String configValue = '${jsonEncode(configDevice.forJson())}\n';
    BluetoothService service = await (configDevice.type == DeviceType.turtle
        ? getTurtleService()
        : getEmergencyService());
    BluetoothCharacteristic characteristicConfig =
        await getConfigCharac(service);
    await characteristicConfig.write(utf8.encode(configValue));
    await btDevice!.disconnect();
  }

  Future<bool> testWifiDevice(ConfigDevices configDevice) async {
    var config = {
      'ssid': configDevice.ssid,
      'pswd': configDevice.passwd,
    };
    await btDevice!.connect(autoConnect: false);
    String configValue = '${jsonEncode(config)}\n';
    BluetoothService service = await (configDevice.type == DeviceType.turtle
        ? getTurtleService()
        : getEmergencyService());
    BluetoothCharacteristic characteristicConfig = await getWifiCharac(service);
    await characteristicConfig.write(utf8.encode(configValue));
    // normaly we'll be disconnected
    await for (BluetoothDeviceState event in btDevice!.state) {
      if (event == BluetoothDeviceState.disconnected) {
        print("disconnected");
        break;
      }
    }
    //so we have to wait when device set bluetooth on
    bool isDeviceFound = await findDevice(configDevice.type, 30);
    if (isDeviceFound) {
      await btDevice!.connect();
      service = await (configDevice.type == DeviceType.turtle
          ? getTurtleService()
          : getEmergencyService());
      characteristicConfig = await getWifiResultCharac(service);
      var resultRead = await characteristicConfig.read();
      var result = String.fromCharCodes(resultRead);
      await btDevice!.disconnect();
      if (result == "OK") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<BluetoothService> getTurtleService() async {
    return await getService(btDevice!, Guid(UUID_TURTLE));
  }

  Future<BluetoothService> getEmergencyService() async {
    return await getService(btDevice!, Guid(UUID_EMERGENCY));
  }

  Future<BluetoothService> getService(BluetoothDevice device, Guid guid) async {
    List<BluetoothService> services = await device.discoverServices();
    BluetoothService? service;
    for (int j = 0; j < services.length; j++) {
      if (services[j].uuid == guid) {
        service = services[j];
      }
    }
    return service!;
  }

  Future<BluetoothCharacteristic> getWifiCharac(
      BluetoothService service) async {
    List<BluetoothCharacteristic> characteristics = service.characteristics;
    return characteristics.firstWhere((characteristic) =>
        characteristic.uuid == Guid("0de42c08-4f89-11eb-ae93-0242ac130023"));
  }

  Future<BluetoothCharacteristic> getWifiResultCharac(
      BluetoothService service) async {
    List<BluetoothCharacteristic> characteristics = service.characteristics;
    return characteristics.firstWhere((characteristic) =>
        characteristic.uuid == Guid("0de42c08-4f89-11eb-ae93-0242ac130024"));
  }

  Future<BluetoothCharacteristic> getConfigCharac(
      BluetoothService service) async {
    List<BluetoothCharacteristic> characteristics = service.characteristics;
    return characteristics.firstWhere((characteristic) =>
        characteristic.uuid == Guid("0de42c08-4f89-11eb-ae93-0242ac130002"));
  }
}
