import 'package:turtle_package/data/communication/socket/box_socket_state.dart';

abstract class BoxCommunication {
  Future<void> start(String ip);

  Stream<BoxSocketState> listeningDeviceEvent();

  Future<void> newMessageReceived(String idTurtle);

  Future<void> stop();

  Future<void> boxIsConfig(String idBox);

  Future<void> disconnectAllTurtle();

  Future<void> acceptSmartphone();

  Future<void> notAcceptedSmartphone();

  Future<void> askSmartphoneForPassword();
}
