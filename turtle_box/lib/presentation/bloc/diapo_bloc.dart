import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/model/message.dart';

import 'diapo_state.dart';

class DiapoBloc extends Cubit<DiapoState> {
  final MessageRepository messageRepository;

  DiapoBloc(
      {required this.messageRepository,
      required this.idTurtle,
      required this.messages,
      required this.newMessagesDiapo})
      : super(DiapoInit());
  int messagesPtr = -1;
  List<Message> messages;
  String idTurtle;
  bool newMessagesDiapo;
  Message? actualMessage;

  Future<void> nextDiapo() async {
    if (actualMessage != null &&
        state != DiapoShowVocalRecorder(actualMessage: actualMessage!) &&
        newMessagesDiapo) {
      print("set message read");
      if (actualMessage! is MessageWithText) {
        (actualMessage as MessageWithText).read = true;
        await messageRepository.setMessageRead(idTurtle, actualMessage!);

        if ((actualMessage! as MessageWithText).needVocalAnswer) {
          emit(DiapoShowVocalRecorder(actualMessage: actualMessage!));
          return;
        }
      }
    }
    messagesPtr++;
    if (messagesPtr > messages.length - 1) {
      emit(DiapoEnd());
    } else {
      actualMessage = messages[messagesPtr];
      if (actualMessage!.type == MessageType.text) {
        emit(DiapoShowText(actualMessage: actualMessage as TextMessage));
      } else if (actualMessage!.type == MessageType.image) {
        emit(DiapoShowImage(actualMessage: actualMessage as ImageMessage));
      } else if (actualMessage!.type == MessageType.video) {
        emit(DiapoShowVideo(actualMessage: actualMessage as VideoMessage));
      } else if (actualMessage!.type == MessageType.youtubeVideo) {
        emit(DiapoShowYoutubeVideo(
            actualMessage: actualMessage as YoutubeMessage));
      }
    }
  }
}
