import 'dart:io';
import 'dart:typed_data';

import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/model/message.dart';

class PhoneMessageUseCase {
  final MessageRepository messageRepository;
  final UploadRepository uploadRepository;
  PhoneMessageUseCase(
      {required this.messageRepository, required this.uploadRepository});

  Future<void> sendMessage(Message message, String idDevice) {
    return messageRepository.sendMessage(message, idDevice);
  }

  Future<List<Message>> getMessages(String idDevice, String idUser) {
    return messageRepository.getMessages(idDevice, idUser);
  }

  Future<List<Message>> getMoreMessages(String idDevice, String idUser,
      {String? lastIndex}) {
    return messageRepository.getMoreMessages(idDevice, idUser,
        lastIndex: lastIndex);
  }

  Stream<MessageModified?> listenMessage(String idDevice, String idUser) {
    return messageRepository.listenMessage(idDevice, idUser);
  }

  Future<void> stopListeningMessage(String idDevice) {
    return messageRepository.stopListeningDeviceMessage(idDevice);
  }

  Future<void> sendMessageWithDatas(
      Message message, List<Uint8List> files, String idDevice) async {
    List<String> ids;
    if (message is ImageMessage) {
      ids = await uploadRepository.uploadImagesDatas(files, idDevice);
      message.link = ids;
    } else if (message is VideoMessage) {
      ids = await uploadRepository.uploadVideosDatas(files, idDevice);
      message.link = ids;
    } else if (message is VocalMessage) {
      String ids =
          await uploadRepository.uploadSoundDatas(files.first, idDevice);
      message.link = [ids];
    }

    return messageRepository.sendMessage(message, idDevice);
  }

  Future<void> sendMessageWithFiles(
      Message message, List<File> files, String idDevice) async {
    if (message is ImageMessage) {
      List<String> ids =
          await uploadRepository.uploadImagesFiles(files, idDevice);
      message.link = ids;
    } else if (message is VideoMessage) {
      List<String> ids =
          await uploadRepository.uploadVideosFiles(files, idDevice);
      message.link = ids;
    } else if (message is VocalMessage) {}
    return messageRepository.sendMessage(message, idDevice);
  }
}
