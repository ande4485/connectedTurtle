import 'package:equatable/equatable.dart';

abstract class InitDeviceState extends Equatable {
  const InitDeviceState();

  @override
  List<Object> get props => [];
}

/// all error events
class InitPhoneError extends InitDeviceState {}

class InitPhoneNoDeviceFound extends InitPhoneError {}

class BoxConnectionError extends InitPhoneError {
  final String error;

  BoxConnectionError({required this.error});
}

class BoxErrorAddress extends InitPhoneError {}

class InitWifiError extends InitPhoneError {}

class ErrorCreationTurtle extends InitPhoneError {}

class InitWifiNOK extends InitPhoneError {}

///event when init is quering something, long event ...
class InitPhoneProcessing extends InitDeviceState {}

class InitPhoneSetup extends InitDeviceState {}

class InitDeviceFound extends InitDeviceState {
  const InitDeviceFound();
}

class BoxConnected extends InitDeviceState {
  final bool connected;

  const BoxConnected({required this.connected});

  @override
  List<Object> get props => [connected];
}

class BoxAskForPassword extends InitDeviceState {}

class InitSearchDevice extends InitDeviceState {}

class InitWifiOK extends InitDeviceState {}

class BtStartConfig extends InitDeviceState {}

class PhoneSsid extends InitDeviceState {
  final String ssid;

  const PhoneSsid({required this.ssid});

  @override
  List<Object> get props => [ssid];

  @override
  String toString() => 'InitListSsids { posts: ${ssid.length}}';
}

class BtSetupEnd extends InitDeviceState {}
