import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/box_message_usecase.dart';
import 'package:turtle_package/model/message.dart';

import 'box_message_state.dart';

class BoxMessageBloc extends Cubit<BoxMessageState> {
  final BoxMessageUseCase messageUseCase;

  BoxMessageBloc({required this.messageUseCase}) : super(MessageInit());

  Future<void> setMessageRead(String idTurtle, Message message) async {
    await messageUseCase.setMessageRead(idTurtle, message);
  }

  Future<void> getNewMessages(String idTurtle) async {
    emit(MessageLoad());
    try {
      var list = await messageUseCase.getNewMessages(idTurtle);
      emit(MessageList(messages: list));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLastMessages(String idTurtle) async {
    emit(MessageLoad());
    try {
      var list = await messageUseCase.getLastMessages(idTurtle);
      emit(MessageList(messages: list));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getFamilyMessages(String idTurtle) async {
    emit(MessageLoad());
    try {
      var list = await messageUseCase.getFamilyMessages(idTurtle);
      emit(MessageList(messages: list));
    } catch (e) {
      print(e);
    }
  }
}
