import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';

import 'package:turtle_package/model/message.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_state.dart';

import '../../domain/usecase/phone_message_usecase.dart';

class PhoneMessageBloc extends Cubit<PhoneMessageState> {
  final String turtleId;
  final String userNameForTurtle;
  final AuthUseCase authUseCase;
  final PhoneMessageUseCase messageUseCase;
  StreamSubscription? _streamSubMessage;
  List<Message> messages = List.empty(growable: true);

  PhoneMessageBloc(
      {required this.messageUseCase,
      required this.authUseCase,
      required this.turtleId,
      required this.userNameForTurtle})
      : super(MessageInit());

  Future<void> sendMessage(Message message) async {
    try {
      AuthDeviceUser? deviceUser = await authUseCase.getAuth();
      if (deviceUser != null) {
        message.fromId = deviceUser.id;
        message.to = turtleId;
        message.fromStr = userNameForTurtle;
        await messageUseCase.sendMessage(message, turtleId);
      }
    } catch (e) {
      print(e);
      emit(MessageNotSend());
    }
  }

  Future<void> sendMessageWithFiles(Message message, List<File> files) async {
    try {
      AuthDeviceUser? deviceUser = await authUseCase.getAuth();
      if (deviceUser != null) {
        message.fromId = deviceUser.id;
        message.to = turtleId;
        message.fromStr = userNameForTurtle;
        await messageUseCase.sendMessageWithFiles(message, files, turtleId);
      }
    } catch (e) {
      print(e);
      emit(MessageNotSend());
    }
  }

  Future<void> sendMessageWithDatas(
      Message message, List<Uint8List> datas) async {
    try {
      AuthDeviceUser? deviceUser = await authUseCase.getAuth();
      if (deviceUser != null) {
        message.fromId = deviceUser.id;
        message.to = turtleId;
        await messageUseCase.sendMessageWithDatas(message, datas, turtleId);
      }
    } catch (e) {
      print(e);
      emit(MessageNotSend());
    }
  }

  Future<void> stopListening() async {
    if (_streamSubMessage != null) {
      await messageUseCase.stopListeningMessage(turtleId);
      await _streamSubMessage!.cancel();
    }
  }

  ///get more messages paging
  Future<void> getMoreMessages() async {
    AuthDeviceUser? deviceUser = await authUseCase.getAuth();
    if (deviceUser != null) {
      List<Message> moreMessages = await messageUseCase.getMoreMessages(
          turtleId, deviceUser.id,
          lastIndex: messages.last.id);
      messages.addAll(moreMessages);
      emit(MessageList(messages: messages.toList(), userId: deviceUser.id));
    }
  }

  ///get messages and listen for messages changes
  Future<void> getMessages() async {
    emit(MessageLoad());
    try {
      AuthDeviceUser? deviceUser = await authUseCase.getAuth();
      if (deviceUser != null) {
        //start listening messages
        _streamSubMessage = messageUseCase
            .listenMessage(turtleId, deviceUser.id)
            .listen((event) {
          if (event != null) {
            if (event.typeChange == MessageTypeChange.Added) {
              messages.add(event.message);
            } else if (event.typeChange == MessageTypeChange.Updated) {
              messages[messages.indexWhere(
                  (element) => element.id == event.message.id)] = event.message;
            } else if (event.typeChange == MessageTypeChange.Deleted) {
              messages.removeWhere((element) => element.id == event.message.id);
            }

            emit(MessageList(
                messages: messages.toList(), userId: deviceUser.id));
          }
        });
        //get messages
        messages
            .addAll(await messageUseCase.getMessages(turtleId, deviceUser.id));
        emit(MessageList(messages: messages.toList(), userId: deviceUser.id));
      }
    } catch (e) {
      emit(MessageGetListError());
    }
  }
}
