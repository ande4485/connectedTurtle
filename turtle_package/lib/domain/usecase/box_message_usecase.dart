import 'package:turtle_package/domain/repository/message_repository.dart';

import 'package:turtle_package/model/message.dart';

class BoxMessageUseCase {
  final MessageRepository messageRepository;

  BoxMessageUseCase({required this.messageRepository});

  Future<void> sendMessage(Message message, String idDevice) {
    return messageRepository.sendMessage(message, idDevice);
  }

  Future<void> setMessageRead(String idDevice, Message message) {
    return messageRepository.setMessageRead(idDevice, message);
  }

  Future<List<Message>> getNewMessages(String idDevice) {
    return messageRepository.getNewMessages(idDevice);
  }

  Future<List<Message>> getLastMessages(String idDevice) {
    return messageRepository.getLastMessages(idDevice);
  }

  Future<List<Message>> getFamilyMessages(String idDevice) {
    return messageRepository.getFamilyMessages(idDevice);
  }
}
