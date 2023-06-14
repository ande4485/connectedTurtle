import 'package:turtle_package/model/message.dart';

abstract class MessageRepository {
  Future<void> sendMessage(Message message, String idDevice);

  Stream<List<Message>> deviceMessages(String idDevice);

  Future<void> setMessageRead(String idDevice, Message message);

  Future<List<Message>> getMoreMessages(String idDevice, String idUser,
      {String? lastIndex});

  Future<List<Message>> getMessages(String idDevice, String idUser);

  Future<List<Message>> getNewMessages(String idDevice);

  Future<List<Message>> getLastMessages(String idDevice);

  Future<List<Message>> getFamilyMessages(String idDevice);

  Future<void> stopListeningDeviceMessage(String idDevice);

  Stream<MessageModified?> listenMessage(String idDevice, String idUser);
}
