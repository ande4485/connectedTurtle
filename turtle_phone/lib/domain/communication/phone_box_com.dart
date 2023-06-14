import 'package:turtle_package/data/communication/socket/phone_box_socket_state.dart';
import 'package:turtle_package/model/device.dart';

abstract class PhoneBoxCommunication {
  Future<void> dispose();

  Future<void> connect(String ipAddr);

  Future<void> setConfig(String id, String email, String pswdBox);

  Future<void> addTurtle(Turtle turtle);

  Future<void> addEmergency(Emergency emergency);

  Future<void> isConfig();

  Future<void> disconnect();

  Stream<PhoneBoxSocketState> listenBoxEvent();

  Future<void> sendPasswordToBox(String password);
}
