import 'package:turtle_package/data/communication/socket/box_socket_state.dart';
import 'package:turtle_package/data/communication/socket/socket_server.dart';

import '../../domain/communication/box_turtle_com.dart';

class BoxComImpl extends BoxCommunication {
  final SocketServer socketServer;

  BoxComImpl({required this.socketServer});

  @override
  Stream<BoxSocketState> listeningDeviceEvent() {
    return socketServer.listenEvent();
  }

  @override
  Future<void> newMessageReceived(String idTurtle) {
    return socketServer.newMessageReceived(idTurtle);
  }

  @override
  Future<void> start(String ip) {
    return socketServer.start(ip);
  }

  @override
  Future<void> stop() {
    return socketServer.stop();
  }

  @override
  Future<void> boxIsConfig(String idBox) {
    return socketServer.boxIsConfig(idBox);
  }

  @override
  Future<void> disconnectAllTurtle() {
    return socketServer.disconnectAllTurtle();
  }

  @override
  Future<void> acceptSmartphone() {
    return socketServer.acceptSmartphone();
  }

  @override
  Future<void> notAcceptedSmartphone() {
    return socketServer.notAcceptedSmartphone();
  }

  @override
  Future<void> askSmartphoneForPassword() {
    return socketServer.askSmartphoneForPassword();
  }
}
