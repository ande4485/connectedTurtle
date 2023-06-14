import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/device.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

class DeviceInit extends DeviceState {}

class DeviceProcessing extends DeviceState {}

class DeviceSettings extends DeviceState {
  final Device device;

  const DeviceSettings({required this.device});

  @override
  List<Object> get props => [device];
}

class ListDevices extends DeviceState {
  final List<Device> devices;
  const ListDevices({required this.devices});

  @override
  List<Object> get props => [devices];
}

class ListDevicesError extends DeviceState {}

class DeviceError extends DeviceState {}

class DeviceProcessDone extends DeviceState {}

class DeviceNotFound extends DeviceState {}
