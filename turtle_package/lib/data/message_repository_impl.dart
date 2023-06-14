import 'package:turtle_package/data/remote/remote_message_datasource.dart';

import 'package:turtle_package/domain/repository/message_repository.dart';

import 'package:turtle_package/model/message.dart';

class MessageRepositoryImpl extends MessageRepository {
  final RemoteMessageDataSource remoteMessageDataSource;

  MessageRepositoryImpl({
    required this.remoteMessageDataSource,
  });

  Future<void> sendMessage(Message message, String idDevice) {
    return remoteMessageDataSource.sendMessage(message, idDevice);
  }

  @override
  Stream<List<Message>> deviceMessages(String idDevice) async* {
    await for (var list in remoteMessageDataSource.deviceMessages(idDevice)) {
      List<Message> newList = List.empty(growable: true);
      for (Message message in list) {
        newList.add(message);
        // if (message.type != MessageType.videoCall.index) {
        //   await localMessageDataSource.saveMessage(message);
        // }
      }
      yield newList;
    }
  }

  Future<List<Message>> getMessages(String idDevice, String idUser) {
    return remoteMessageDataSource.getMessages(idDevice, idUser);
  }

  @override
  Future<List<Message>> getFamilyMessages(String idDevice) {
    return remoteMessageDataSource.getFamilyMessages(idDevice);
  }

  @override
  Future<List<Message>> getLastMessages(String idDevice) {
    return remoteMessageDataSource.getLastMessages(idDevice);
  }

  @override
  Future<List<Message>> getNewMessages(String idDevice) {
    return remoteMessageDataSource.getNewMessages(idDevice);
  }

  @override
  Future<void> setMessageRead(String idDevice, Message message) async {
    return remoteMessageDataSource.setMessageRead(idDevice, message);
  }

  @override
  Future<void> stopListeningDeviceMessage(String idDevice) {
    return remoteMessageDataSource.stopListeningDeviceMessage(idDevice);
  }

  @override
  Stream<MessageModified?> listenMessage(String idDevice, String idUser) {
    return remoteMessageDataSource.listenMessage(idDevice, idUser);
  }

  @override
  Future<List<Message>> getMoreMessages(String idDevice, String idUser,
      {String? lastIndex}) {
    return remoteMessageDataSource.getMoreMessages(idDevice, idUser,
        lastIndex: lastIndex);
  }
}
