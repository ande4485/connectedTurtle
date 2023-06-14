import 'package:turtle_package/model/message.dart';

abstract class RemoteMessageDataSource {
  Stream<List<Message>> deviceMessages(String idTurtle);

  Future<void> sendMessage(Message message, String turtleId);

  Future<List<Message>> getMoreMessages(String idDevice, String idUser,
      {String? lastIndex});

  Future<List<Message>> getMessages(String idDevice, String idUser);

  Future<void> setMessageRead(String idTurtle, Message message);

  Future<void> stopListeningDeviceMessage(String idTurtle);

  Stream<MessageModified?> listenMessage(String idDevice, String idUser);

  Future<List<Message>> getFamilyMessages(String idDevice);

  Future<List<Message>> getLastMessages(String idDevice);

  Future<List<Message>> getNewMessages(String idDevice);
}
