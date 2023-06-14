import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:turtle_package/model/device.dart';

import 'phone_box_socket_state.dart';

class MessageToBox {
  final String action;
  final String type;
  final String idServer;
  final String id;
  final String email;
  final String password;

  MessageToBox(
      {required this.action,
      required this.type,
      required this.idServer,
      required this.id,
      required this.email,
      required this.password});
}

class SocketClient {
  late Socket? _socket;
  final controller = StreamController<PhoneBoxSocketState>();
  late StreamSubscription<Uint8List> listener;
  final JsonDecoder _jsonDecoder = JsonDecoder();
  final JsonEncoder _jsonEncoder = JsonEncoder();

  Future<void> connect(String ipAddress) async {
    _socket = await Socket.connect(ipAddress, 8585)
        .timeout(Duration(seconds: 10), onTimeout: () => throw TimeOutError())
        .then((socket) {
      var identification = {"action": "id", "type": "smartphone"};
      socket.add(_jsonEncoder.convert(identification).codeUnits);
      socket.flush();
      listener = socket.listen((event) {
        var msg = _jsonDecoder.convert(String.fromCharCodes(event));

        if (msg['action'] == 'IS_CONFIG_BOX') {
          controller.sink.add(BoxSocketIsConfig(idBox: (msg['value'])));
        } else if (msg['action'] == 'ASK_PASSWORD') {
          controller.sink.add(BoxAskPassword());
        } else if (msg['action'] == 'SMARTPHONE_ACCEPTED') {
          print("tel received : emit box accept smartphone");
          controller.sink.add(BoxAcceptSmartphone());
        }
      });
      listener.onDone(() async {
        await disconnect();
      });
      return socket;
    });
  }

  Future<void> disconnect() async {
    print("disconnect phone");
    if (_socket != null) {
      _socket!.close();
      _socket = null;
      await listener.cancel();
      await controller.close();
    }
  }

  Stream<PhoneBoxSocketState> listenBoxEvent() {
    return controller.stream;
  }

  Future<void> addTurtle(Turtle turtle) async {
    var configAddTurtle = {
      "action": "ADD_DEVICE",
      "id": "smartphone",
      "turtle": turtle.id,
    };
    _socket!.add(_jsonEncoder.convert(configAddTurtle).codeUnits);
    await _socket!.flush();
  }

  Future<void> addEmergency(Emergency emergency) async {
    var configAddEmergency = {
      "action": "ADD_DEVICE",
      "id": "smartphone",
      "emergency": emergency.id,
      "idTurtle": emergency.turtleId
    };
    _socket!.add(_jsonEncoder.convert(configAddEmergency).codeUnits);
    await _socket!.flush();
  }

  Future<void> isConfig() async {
    var configGet = {"action": "IS_CONFIG", "id": "smartphone"};
    _socket!.add(_jsonEncoder.convert(configGet).codeUnits);
    //await _socket!.flush();
  }

  Future<void> setConfig(String id, String email, String passwordBox) async {
    var configSet = {
      "action": "SETUP_CONFIG",
      "id": "smartphone",
      "email": "$email",
      "passwd": "$passwordBox",
      "idBox": id
    };
    _socket!.add(_jsonEncoder.convert(configSet).codeUnits);
    await _socket!.flush();
  }

  Future<void> sendPassword(String password) async {
    var configSet = {
      "action": "PASSWORD",
      "id": "smartphone",
      "password": password
    };
    _socket!.add(_jsonEncoder.convert(configSet).codeUnits);
    await _socket!.flush();
  }
}

class TimeOutError extends Error {}
