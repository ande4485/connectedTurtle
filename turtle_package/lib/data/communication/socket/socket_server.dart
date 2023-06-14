import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:turtle_package/model/device.dart';

import 'box_socket_state.dart';

class SocketServer {
  final StreamController<BoxSocketState> _controller =
      StreamController<BoxSocketState>();
  late Isolate _isolate;
  late ReceivePort _receive;
  late SendPort _portComWithWebServer;

  Future<void> disconnectAllTurtle() async {
    _portComWithWebServer.send(DisconnectAllTurtle());
  }

  Future start(String ip) async {
    _receive = ReceivePort();

    _receive.listen((message) {
      if (message is SendPort) {
        _portComWithWebServer = message;
        _portComWithWebServer.send(InitWebSocketSever(ip: ip));
      } else
        _controller.add(message);
    });
    //return compute(onSocketData, _receive.sendPort);
    _isolate = await Isolate.spawn(onSocketData, _receive.sendPort);
  }

  Future<void> stop() async {
    _controller.close();
    _isolate.kill();
  }

  Future<void> boxIsConfig(String idBox) async {
    var data = {"action": "IS_CONFIG_BOX", "value": idBox};
    _portComWithWebServer.send(SendMessageToPhone(data: data));
  }

  Future<void> newMessageReceived(String idTurtle) async {
    var data = {"action": "NEW_MESSAGES", "id": idTurtle};
    _portComWithWebServer
        .send(SendMessageToTurtle(data: data, idTurtle: idTurtle));
  }

  Stream<BoxSocketState> listenEvent() {
    return _controller.stream;
  }

  Future askSmartphoneForPassword() async {
    _portComWithWebServer.send(ServerAskSmartphonePassword());
  }

  Future<void> acceptSmartphone() async {
    _portComWithWebServer.send(ServerAcceptSmartphone());
  }

  Future<void> notAcceptedSmartphone() async {
    _portComWithWebServer.send(ServerNotAcceptSmartphone());
  }

  static void onSocketData(SendPort sendPort) {
    HashMap<String, Socket> _connectionsDevice = HashMap<String, Socket>();
    Socket? connectionSmartphoneWaitAccept;
    Socket? connectionSmartphone;
    final JsonDecoder jsonDecoder = JsonDecoder();
    final JsonEncoder jsonEncoder = JsonEncoder();
    ReceivePort r = ReceivePort();
    ServerSocket? server;
    sendPort.send(r.sendPort);
    r.listen((message) async {
      print("message $message");
      if (message is InitWebSocketSever) {
        print("server starting" + message.ip);
        server = await ServerSocket.bind(message.ip, 8585, shared: true);
        print("server started");

        await for (Socket client in server!.asBroadcastStream()) {
          await for (var data in client.asBroadcastStream()) {
            // client.asBroadcastStream(onListen: (subscription) {

            // subscription.onData(
            //        (data) {
            print("server client:" + String.fromCharCodes(data));
            var msg = jsonDecoder.convert(String.fromCharCodes(data));
            print(msg['action']);
            //turtle connect to this with an id
            if (msg['action'] == 'id') {
              if (msg['type'] == "remote-turtle") {
                sendPort.send(DeviceConnected(
                    id: msg['id'], deviceType: DeviceType.turtle));
                _connectionsDevice[msg['id']] = client;
              } else if (msg['type'] == "smartphone" &&
                  connectionSmartphone == null &&
                  connectionSmartphoneWaitAccept == null) {
                sendPort.send(AcceptSmartphone());
                connectionSmartphoneWaitAccept = client;
              } else if (msg['type'] == "emergency") {
                sendPort.send(DeviceConnected(
                    id: msg['id'], deviceType: DeviceType.emergency));
                _connectionsDevice[msg['id']] = client;
              }
            }
            //add a turtle to the box
            else if (msg['action'] == 'ADD_DEVICE' &&
                msg['id'] == 'smartphone' &&
                connectionSmartphone != null) {
              if (msg['turtle'] != null) {
                sendPort.send(AddTurtle(turtle: msg['turtle']));
              } else if (msg['emergency'] != null) {
                sendPort.send(AddEmergency(
                    emergency: msg['emergency'], idTurtle: msg['idTurtle']));
              }
            }
            //setup connection with firebase
            else if (msg['action'] == 'SETUP_CONFIG' &&
                msg['id'] == 'smartphone' &&
                connectionSmartphone != null) {
              sendPort.send(SetUpBoxAuth(
                  id: msg['idBox'],
                  email: msg['email'],
                  password: msg['passwd']));
            } else if (msg['action'] == 'TURTLE_TAP') {
              sendPort.send(TurtleTapped(id: msg['id']));
            } else if (msg['action'] == 'EMERGENCY_TAP') {
              sendPort.send(EmergencyTapped(
                  idEmmergency: msg['idTurtle'], message: msg['message']));
            } else if (msg['action'] == 'IS_CONFIG' &&
                msg['id'] == 'smartphone' &&
                connectionSmartphone != null) {
              sendPort.send(BoxIsConfig());
              //controller.sink.add();
            } else if (msg['action'] == 'PASSWORD' &&
                msg['id'] == 'smartphone' &&
                connectionSmartphoneWaitAccept != null) {
              sendPort.send(SmartphonePassword(password: msg['password']));

              //controller.sink.add();
            }
          }
        }

        /** onCancel: (subscription) {
              if (client == connectionSmartphone)
                connectionSmartphone = null;
              else if (_connectionsDevice.containsValue(client)) {
                var idDevice = _connectionsDevice.entries.firstWhere((element) => element.value==client).key;
                _connectionsDevice
                    .removeWhere((key, value) => value == client);
                sendPort.send(DeviceDisconnected(idDevice: idDevice));
              }
            });**/
      } else if (message is DisconnectAllTurtle) {
        for (var turtle in _connectionsDevice.entries) {
          turtle.value.close();
          _connectionsDevice.remove(turtle.key);
        }
      } else if (message is SendMessageToPhone) {
        if (connectionSmartphone != null)
          connectionSmartphone!.write(jsonEncoder.convert(message.data));
        await connectionSmartphone!.flush();
      } else if (message is SendMessageToTurtle) {
        _connectionsDevice[message.idTurtle]!
            .write(jsonEncoder.convert(message.data));
        await _connectionsDevice[message.idTurtle]!.flush();
      } else if (message is ServerAcceptSmartphone) {
        connectionSmartphone = connectionSmartphoneWaitAccept;
        connectionSmartphone!
            .write(jsonEncoder.convert({"action": "SMARTPHONE_ACCEPTED"}));
        await connectionSmartphone!.flush();
      } else if (message is ServerAskSmartphonePassword) {
        connectionSmartphoneWaitAccept!
            .write(jsonEncoder.convert({"action": "ASK_PASSWORD"}));
        await connectionSmartphoneWaitAccept!.flush();
      } else if (message is ServerNotAcceptSmartphone) {
        print("smartphone close");
        //var socketSmartphone = await server!.firstWhere((element) => element == connectionSmartphoneWaitAccept!);
        connectionSmartphoneWaitAccept!.destroy(); // close();
        connectionSmartphone = null;
        connectionSmartphoneWaitAccept = null;
      }
    });
  }
}
