import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/device.dart';

abstract class BoxSocketState extends Equatable {
  const BoxSocketState();

  @override
  List<Object> get props => [];
}

class TurtleInit extends BoxSocketState {}

class TurtleTapped extends BoxSocketState {
  final String id;

  const TurtleTapped({required this.id});

  @override
  List<Object> get props => [id];
}

class EmergencyTapped extends BoxSocketState {
  final String idEmmergency;
  final String message;

  EmergencyTapped({required this.idEmmergency, required this.message});

  @override
  List<Object> get props => [idEmmergency, message];
}

class AddTurtle extends BoxSocketState {
  final String turtle;

  AddTurtle({required this.turtle});

  @override
  List<Object> get props => [turtle];
}

class AddEmergency extends BoxSocketState {
  final String emergency;
  final String idTurtle;
  AddEmergency({required this.emergency, required this.idTurtle});

  @override
  List<Object> get props => [emergency, idTurtle];
}

class SetUpBoxAuth extends BoxSocketState {
  final String id;
  final String email;
  final String password;
  SetUpBoxAuth({required this.id, required this.email, required this.password});

  @override
  List<Object> get props => [id, email, password];
}

class BoxIsConfig extends BoxSocketState {}

class SmartphonePassword extends BoxSocketState {
  final String password;
  SmartphonePassword({required this.password});

  @override
  List<Object> get props => [password];
}

class DeviceDisconnected extends BoxSocketState {
  final String idDevice;
  final DeviceType deviceType;
  DeviceDisconnected({required this.idDevice, required this.deviceType});

  @override
  List<Object> get props => [idDevice, deviceType];
}

class DeviceConnected extends BoxSocketState {
  final String id;
  final DeviceType deviceType;
  DeviceConnected({required this.id, required this.deviceType});

  @override
  List<Object> get props => [id, deviceType];
}

class SmartphoneConnected extends BoxSocketState {
  SmartphoneConnected();

  @override
  List<Object> get props => [];
}

class AcceptSmartphone extends BoxSocketState {
  AcceptSmartphone();

  @override
  List<Object> get props => [];
}

class EmergencyConnected extends BoxSocketState {
  final String id;

  EmergencyConnected({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class Disconnection extends BoxSocketState {
  final Socket socket;
  Disconnection({required this.socket});

  @override
  List<Object> get props => [socket];
}

class InitWebSocketSever extends BoxSocketState {
  final String ip;
  InitWebSocketSever({required this.ip});

  @override
  List<Object> get props => [ip];
}

class DisconnectAllTurtle extends BoxSocketState {
  DisconnectAllTurtle();

  @override
  List<Object> get props => [];
}

class SendMessageToPhone extends BoxSocketState {
  final data;
  SendMessageToPhone({required this.data});

  @override
  List<Object> get props => [data];
}

class SendMessageToTurtle extends BoxSocketState {
  final data;
  final String idTurtle;
  SendMessageToTurtle({required this.data, required this.idTurtle});

  @override
  List<Object> get props => [data, idTurtle];
}

class ServerAcceptSmartphone extends BoxSocketState {}

class ServerNotAcceptSmartphone extends BoxSocketState {}

class ServerAskSmartphonePassword extends BoxSocketState {}
