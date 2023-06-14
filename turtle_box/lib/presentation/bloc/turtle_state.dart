import 'package:equatable/equatable.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

class DeviceStart extends DeviceState {}

class DeviceNewMessage extends DeviceState {}
