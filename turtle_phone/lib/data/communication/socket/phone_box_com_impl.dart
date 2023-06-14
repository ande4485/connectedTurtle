import 'package:turtle_package/data/communication/socket/phone_box_socket_state.dart';
import 'package:turtle_package/data/communication/socket/socket_client.dart';
import 'package:turtle_package/model/device.dart';

import '../../../domain/communication/phone_box_com.dart';

class PhoneBoxComImpl extends PhoneBoxCommunication {
  SocketClient? socketClient;

  PhoneBoxComImpl();

  @override
  Future<void> addTurtle(Turtle turtle) {
    return socketClient!.addTurtle(turtle);
  }

  @override
  Future<void> addEmergency(Emergency emergency) {
    return socketClient!.addEmergency(emergency);
  }

  @override
  Future<void> connect(String ipAddr) {
    socketClient = SocketClient();
    return socketClient!.connect(ipAddr);
  }

  @override
  Future<void> disconnect() {
    return socketClient!.disconnect();
  }

  @override
  Future<void> isConfig() async {
    await socketClient!.isConfig();
  }

  @override
  Future<void> setConfig(String id, String email, String pswdBox) {
    return socketClient!.setConfig(id, email, pswdBox);
  }

  @override
  Future<void> dispose() async {
    if (socketClient != null) socketClient!.disconnect();
  }

  @override
  Stream<PhoneBoxSocketState> listenBoxEvent() {
    return socketClient!.listenBoxEvent();
  }

  @override
  Future<void> sendPasswordToBox(String password) {
    return socketClient!.sendPassword(password);
  }
}
