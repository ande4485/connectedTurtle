import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

import '../../domain/usecase/init_phone_usecase.dart';
import 'init_device_state.dart';

class InitDeviceBloc extends Cubit<InitDeviceState> {
  final InitPhoneUseCase initPhoneUseCase;

  InitDeviceBloc({required this.initPhoneUseCase}) : super(InitPhoneSetup());

  Future<void> connectToBox(String ipBox) async {
    emit(InitPhoneProcessing());
    try {
      var askForSmartphone = await initPhoneUseCase.connectToBox(ipBox);
      //var askForSmartphone = true;
      if (askForSmartphone) {
        emit(BoxAskForPassword());
      } else {
        emit(BoxErrorAddress());
      }
    } catch (e) {
      print("error socket");
      emit(BoxConnectionError(error: e.toString()));
    }
  }

  Future<void> dispose() async {
    initPhoneUseCase.dispose();
  }

  Future<void> getSSidFromPhone() async {
    String? wifiName = await initPhoneUseCase.getSSid();
    //String wifiName = "test";
    emit(PhoneSsid(ssid: wifiName!));
  }

  Future<void> startConfigTurtle() async {
    emit(BtStartConfig());
  }

  Future<void> sendPassword(String password) async {
    try {
      var accepted = await initPhoneUseCase.sendPasswordToBox(password);
      //var accepted = true;
      if (accepted) {
        emit(BoxConnected(connected: accepted));
      }
    } catch (e) {
      emit(BoxConnectionError(error: e.toString()));
    }
  }

  Future<void> testWifiDevice(ConfigDevices configDevice) async {
    emit(InitPhoneProcessing());
    try {
      bool wifiConnected = await initPhoneUseCase.testWifiDevice(configDevice);
      if (wifiConnected) {
        emit(InitWifiOK());
      } else {
        emit(InitWifiNOK());
      }
    } catch (e) {
      emit(InitWifiError());
    }
  }

  Future<void> findDevice(DeviceType deviceType) async {
    emit(InitSearchDevice());
    try {
      bool found = await initPhoneUseCase.findDevice(deviceType);
      //bool found = true;
      if (found) {
        emit(const InitDeviceFound());
      } else {
        emit(InitPhoneNoDeviceFound());
      }
    } catch (e) {
      emit(InitPhoneNoDeviceFound());
    }
  }

  Future<void> createDeviceAndBox(ConfigDevices configDevices) async {
    emit(InitPhoneProcessing());
    try {
      await initPhoneUseCase.createDevicesAndBox(configDevices);
      emit(BtSetupEnd());
    } catch (e) {
      emit(ErrorCreationTurtle());
    }
  }
}
