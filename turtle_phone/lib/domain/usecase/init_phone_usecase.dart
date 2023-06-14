import 'dart:async';

import 'package:turtle_package/data/communication/socket/phone_box_socket_state.dart';
import 'package:turtle_package/domain/repository/box_create_repository.dart';

import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

import '../communication/phone_box_com.dart';
import '../communication/phone_turtle_com.dart';
import '../config/wifi_information.dart';

class InitPhoneUseCase {
  final PhoneDeviceCommunication phoneDeviceCommunication;
  final PhoneBoxCommunication phoneBoxCommunication;
  final DeviceRepository deviceRepository;
  final WifiInformation wifiInformation;
  final BoxCreateRepository boxCreateRepository;
  late Stream boxEventSubscription;

  InitPhoneUseCase(
      {required this.phoneBoxCommunication,
      required this.phoneDeviceCommunication,
      required this.deviceRepository,
      required this.wifiInformation,
      required this.boxCreateRepository});

  Future<void> dispose() async {
    //boxEventSubscription.cancel();
    phoneBoxCommunication.dispose();
    phoneDeviceCommunication.dispose();
  }

  Future<bool> testWifiDevice(ConfigDevices configDevice) {
    return phoneDeviceCommunication.testWifiDevice(configDevice);
  }

  Future<bool> findDevice(DeviceType deviceType) {
    return phoneDeviceCommunication.findDevice(deviceType);
  }

  Future<bool> connectToBox(String ipBox) async {
    await phoneBoxCommunication.connect(ipBox);
    boxEventSubscription =
        phoneBoxCommunication.listenBoxEvent().asBroadcastStream();
    var eventConnected = await boxEventSubscription.first;

    return eventConnected is BoxAskPassword;
  }

  Future<bool> sendPasswordToBox(String password) async {
    await phoneBoxCommunication.sendPasswordToBox(password);

    var eventConnected = await boxEventSubscription.first;
    return eventConnected is BoxAcceptSmartphone;
  }

  Stream<PhoneBoxSocketState> listenBoxEvent() {
    return phoneBoxCommunication.listenBoxEvent();
  }

  Future<String?> getSSid() async {
    return wifiInformation.getSSid();
  }

  Future<void> createDevicesAndBox(ConfigDevices configDevices) async {
    BoxSocketIsConfig isBoxConfigured = await boxEventSubscription.first;
    var idBox = isBoxConfigured.idBox;
    if (idBox.isEmpty) {
      //create box
      var values = await boxCreateRepository.create();
      await phoneBoxCommunication.setConfig(values.$3, values.$1, values.$2);
    }

    Device device = await deviceRepository.createDevice(configDevices, idBox);
    await phoneBoxCommunication.isConfig();

    if (device is Turtle) {
      await phoneBoxCommunication.addTurtle(device);
      await phoneDeviceCommunication.setConfig(configDevices);
    } else if (device is Emergency) {
      ConfigEmergency configEmergency = (configDevices as ConfigEmergency);
      await phoneBoxCommunication.addEmergency(device);
      await phoneDeviceCommunication.setConfig(configEmergency);
    }
  }
}
