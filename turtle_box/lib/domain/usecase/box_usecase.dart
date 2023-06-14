import 'dart:async';

import 'package:turtle_box/domain/communication/box_turtle_com.dart';
import 'package:turtle_box/domain/config/box_config.dart';
import 'package:turtle_box/domain/password_generator/password_generator.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/bloc/turtle_state.dart';
import 'package:turtle_box/presentation/screen/design/constant.dart';
import 'package:turtle_package/data/communication/socket/box_socket_state.dart';
import 'package:turtle_package/domain/repository/auth_repository.dart';
import 'package:turtle_package/domain/repository/box_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

class DeviceConnection {
  String id;
  Device device;
  DeviceState deviceState;
  StreamSubscription? streamSubscription;

  DeviceConnection(
      {required this.id,
      required this.device,
      required this.deviceState,
      this.streamSubscription});
}

class BoxUseCase {
  final BoxCommunication boxCommunication;
  final AuthRepository authRepository;
  final MessageRepository messageRepository;
  final BoxRepository boxRepository;
  final DeviceRepository deviceRepository;
  final BoxConfiguration boxConfig;
  final PasswordGenerator passwordGenerator;
  late BoxState boxState;
  late BoxState _boxStateBeforeTimeOut;
  late Timer _timerTimeOut;
  late String _ipAddress;
  final Duration timeOutDuration;
  final Duration timeAfterTimeOut;
  late Timer _timeOutAcceptPhone;
  final Duration timeAcceptPhoneTimeOut;
  final List<DeviceConnection?> deviceConnectedState =
      List.empty(growable: true);
  String currentDeviceId = "";
  final boxStateController = StreamController<BoxState>();

  BoxUseCase({
    required this.boxCommunication,
    required this.authRepository,
    required this.messageRepository,
    required this.boxRepository,
    required this.deviceRepository,
    required this.passwordGenerator,
    required this.boxConfig,
    this.timeAfterTimeOut = timeAfterTimeout,
    this.timeOutDuration = timeout,
    this.timeAcceptPhoneTimeOut = timeAcceptPhoneTimeout,
  });

  Stream<BoxState> boxEvent() {
    return boxStateController.stream;
  }

  void dispose() {
    boxStateController.close();
    boxCommunication.stop();
  }

  void restart() async {
    //Wakelock.disable();
    _stopTimeOut();
    boxState = BoxStart(ip: _ipAddress);
    boxStateController.sink.add(boxState);
    //so check if  device is connected
    var deviceConnection = getDeviceConnection(currentDeviceId);
    if (deviceConnection != null) {
      //so device is connected, we are in a real timeout
      //check if this device has new message
      var listNewMessage =
          await messageRepository.getNewMessages(currentDeviceId);
      if (listNewMessage.isNotEmpty) {
        //so we have to blink turtle
        boxCommunication.newMessageReceived(currentDeviceId);
        //set state of device
        deviceConnection.deviceState = DeviceNewMessage();
      } else {
        deviceConnection.deviceState = DeviceStart();
      }
    }
    currentDeviceId = "";
  }

  Future<String> setConfigAuthBox() async {
    var email = boxRepository.getEmail();
    var password = boxRepository.getPassword();
    if (email != null && password != null) {
      var auth = await authRepository.signIn(email, password);
      if (auth != null) {
        return "";
      } else {
        return auth!.id;
      }
    }
    return "";
  }

  Future<String> getIp() {
    return boxConfig.getIp();
  }

  DeviceConnection? getDeviceConnection(String idDevice) {
    return deviceConnectedState.firstWhere(
        (deviceConnection) => deviceConnection!.id == idDevice,
        orElse: () => null);
  }

  void start() async {
    //so init socket server
    print("start use case");
    boxState = BoxInit();
    _ipAddress = await boxConfig.getIp();
    await boxCommunication.start(_ipAddress);
    // start auth to server
    String idBox = await setConfigAuthBox();

    boxState = BoxStart(ip: _ipAddress);
    boxStateController.sink.add(boxState);
    //now listening
    //var streamTest = ;
    boxCommunication.listeningDeviceEvent().listen((event) async {
      print("event use case $event");
      if (event is DeviceConnected) {
        print("turtle connected");

        String idDevice = event.id;
        Device? connectedDevice =
            await deviceRepository.getDevice(idDevice, event.deviceType);
        //check turtle added if not bad turtle !!!!
        if (connectedDevice != null) {
          if (connectedDevice.deviceType == DeviceType.turtle) {
            //so listen for new messages for this turtle
            var actualDeviceConnection = DeviceConnection(
                id: idDevice,
                device: connectedDevice,
                deviceState: DeviceStart());
            deviceConnectedState.add(actualDeviceConnection);

            //TODO change because there's no new message on stream when listening
            actualDeviceConnection.streamSubscription = messageRepository
                .deviceMessages(connectedDevice.id)
                .listen((event) {
              if (event.isNotEmpty) {
                var deviceConnection = getDeviceConnection(idDevice);
                if (deviceConnection != null &&
                    deviceConnection.deviceState is DeviceStart) {
                  boxCommunication.newMessageReceived(idDevice);
                }
                deviceConnection!.deviceState = DeviceNewMessage();
              }
            });
          } else if (connectedDevice.deviceType == DeviceType.emergency) {
            var actualDeviceConnection = DeviceConnection(
                id: idDevice,
                device: connectedDevice,
                deviceState: DeviceStart());
            deviceConnectedState.add(actualDeviceConnection);
          }
        }
      } else if (event is BoxIsConfig) {
        boxCommunication.boxIsConfig(idBox);
      } else if (event is TurtleTapped) {
        var deviceConnection = getDeviceConnection(event.id);
        if (deviceConnection != null &&
            boxState is BoxStart &&
            deviceConnection.deviceState is DeviceNewMessage) {
          currentDeviceId = event.id;
          //TODO TESTWakelock.enable();
          _startTimeOut();
          boxState =
              BoxDiaporama(actualDevice: deviceConnection.device as Turtle);
          boxStateController.sink.add(boxState);
        } else if (boxState is BoxStart) {
          currentDeviceId = event.id;

          Device? actualDevice = await deviceRepository.getDevice(
              currentDeviceId, DeviceType.turtle);
          if (actualDevice != null) {
            //TODO TESTWakelock.enable();
            _startTimeOut();
            boxState = BoxShowChoices(actualDevice: actualDevice as Turtle);
            boxStateController.sink.add(boxState);
          }
        } else if (boxState is BoxShowChoices ||
            boxState is BoxDiaporama && currentDeviceId == event.id) {
          //choose to listen turtleTapped
          _resetTimeOut();
          boxStateController.sink.add(BoxEventNext(time: DateTime.now()));
        } else if (boxState is BoxTimeOut) {
          _resetTimeOut();
          boxState = _boxStateBeforeTimeOut;
          boxStateController.sink.add(BoxTimeOutStop());
        } else if (boxState is BoxEnded) {
          currentDeviceId = "";
        }
      } else if (event is AddTurtle) {
        boxRepository.addTurtle(event.turtle);
      } else if (event is AddEmergency) {
        //verify turtle exists
        if (await deviceRepository.deviceExist(
            event.idTurtle, DeviceType.turtle)) {
          boxRepository.addEmergency(event.emergency);
        }
      } else if (event is SetUpBoxAuth && idBox.isEmpty) {
        await boxRepository.setConfig(event.id, event.email, event.password);
        await setConfigAuthBox();
        await boxCommunication.disconnectAllTurtle();
      } else if (event is EmergencyTapped) {
        //so we have to send a message to administrator
        Emergency? emmergency = (await deviceRepository.getDevice(
            event.idEmmergency, DeviceType.emergency)) as Emergency?;
        Turtle? turtle = (await deviceRepository.getDevice(
            emmergency!.turtleId, DeviceType.turtle)) as Turtle?;
        if (turtle != null) {
          EmergencyMessage emergencyMessage = EmergencyMessage(
            id: "",
            fromId: turtle.id,
            fromStr: turtle.nameDevice,
            to: "",
            date: DateTime.now(),
            message: event.message,
          );
          messageRepository.sendMessage(emergencyMessage, turtle.id);
        }
      } else if (event is AcceptSmartphone) {
        if (boxState is BoxStart) {
          //if we are not at start state so prohibited
          String words = passwordGenerator.generatePassword();
          boxState = BoxSecurityWords(words: words);
          boxStateController.sink.add(boxState);
          await boxCommunication.askSmartphoneForPassword();
          _timeOutAcceptPhone = Timer(timeAcceptPhoneTimeOut, () async {
            boxState = BoxStart(ip: _ipAddress);
            boxStateController.sink.add(BoxSecurityWordsFalse());
            Future.delayed(const Duration(seconds: 4), () {
              boxStateController.sink.add(boxState);
            });
            await boxCommunication.notAcceptedSmartphone();
          });
        }
      } else if (event is SmartphonePassword) {
        _timeOutAcceptPhone.cancel();
        if (boxState is BoxSecurityWords) {
          if (event.password == passwordGenerator.getLastPassword()) {
            //send accepted smartphone
            boxState = BoxStart(ip: _ipAddress);
            boxStateController.sink.add(BoxSecurityWordsGood());
            Future.delayed(const Duration(seconds: 4), () {
              boxStateController.sink.add(boxState);
            });

            await boxCommunication.acceptSmartphone();
          } else {
            boxState = BoxStart(ip: _ipAddress);
            boxStateController.sink.add(BoxSecurityWordsFalse());
            Future.delayed(const Duration(seconds: 4), () {
              boxStateController.sink.add(boxState);
            });
            await boxCommunication.notAcceptedSmartphone();
          }
        }
      } else if (event is DeviceDisconnected) {
        if (currentDeviceId == event.idDevice) {
          restart();
        }
        var deviceConnection = getDeviceConnection(event.idDevice);
        if (deviceConnection != null &&
            deviceConnection.streamSubscription != null) {
          deviceConnection.streamSubscription!.cancel();
        }
        deviceConnectedState.remove(deviceConnection);
      }
    });
  }

  _startTimeOut() {
    print("start timeOut");
    _timerTimeOut = Timer(timeOutDuration, _timeOutNoActivity);
  }

  _timeOutNoActivity() {
    print("timeOut");
    _boxStateBeforeTimeOut = boxState;
    boxState = BoxTimeOut();
    boxStateController.sink.add(boxState);
    _timerTimeOut.cancel();
    _timerTimeOut = Timer(timeAfterTimeOut, _timeOutEnd);
  }

  _timeOutEnd() async {
    print("restart box");
    _timerTimeOut.cancel();

    restart();
  }

  _resetTimeOut() {
    print("reset timeout");
    _timerTimeOut.cancel();
    _timerTimeOut = Timer(timeOutDuration, _timeOutNoActivity);
  }

  _stopTimeOut() {
    print("stop timeout");
    _timerTimeOut.cancel();
  }
}
