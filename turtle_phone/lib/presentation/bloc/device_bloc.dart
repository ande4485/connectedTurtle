import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/domain/usecase/device_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';
import 'package:turtle_package/model/device.dart';

import 'device_state.dart';

class DeviceBloc extends Cubit<DeviceState> {
  final DeviceUseCase deviceUseCase;
  final AuthUseCase authUseCase;
  StreamSubscription? _deviceListener;

  DeviceBloc({required this.deviceUseCase, required this.authUseCase})
      : super(DeviceInit());

  Future<void> deleteDevice(String idDevice, DeviceType deviceType) async {
    emit(DeviceProcessing());
    try {
      await deviceUseCase.deleteDevice(idDevice, deviceType);
      emit(DeviceProcessDone());
    } catch (e) {
      emit(DeviceError());
    }
  }

  Future<void> stopListenDevice(String idDevice) async {
    if (_deviceListener != null) _deviceListener!.cancel();
  }

  Future<void> listenDevice(String idDevice) async {
    try {
      //_deviceListener = deviceUseCase.listenDevice(idDevice).listen((device) {
      //  if (device != null) {
      //    emit(DeviceProperties(device: device));
      //  } else {
      //    emit(DeviceError());
      //  }
      // });
    } catch (e) {
      emit(DeviceError());
    }
  }

  Future<void> getDevicesByUser(DeviceType deviceType) async {
    try {
      AuthDeviceUser? authDeviceUser = await authUseCase.getAuth();
      if (authDeviceUser != null) {
        var devices =
            await deviceUseCase.getDevicesByUser(authDeviceUser.id, deviceType);
        emit(ListDevices(devices: devices));
      }
    } catch (e) {
      emit(ListDevicesError());
    }
  }

  Future<void> getDeviceSettings(String idDevice, DeviceType deviceType) async {
    emit(DeviceProcessing());
    try {
      Device? device =
          await deviceUseCase.getDeviceSettings(idDevice, deviceType);
      if (device != null) {
        emit(DeviceSettings(device: device));
      } else {
        emit(DeviceError());
      }
    } catch (e) {
      emit(DeviceError());
    }
  }

  Future<void> updateDeviceSettings(Device device) async {
    emit(DeviceProcessing());
    try {
      await deviceUseCase.updateDeviceSettings(device);
    } catch (e) {
      emit(DeviceError());
    }
  }
}
