import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/message.dart';

abstract class BoxMessageState extends Equatable {
  const BoxMessageState();

  @override
  List<Object> get props => [];
}

class MessageLoad extends BoxMessageState {}

class MessageInit extends BoxMessageState {}

class MessageListEmpty extends BoxMessageState {}

class MessageGetListError extends BoxMessageState {}

class MessageSend extends BoxMessageState {}

class MessageNotSend extends BoxMessageState {}

class MessageList extends BoxMessageState {
  final List<Message> messages;

  const MessageList({required this.messages});

  @override
  List<Object> get props => [messages];
}
