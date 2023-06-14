import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/message.dart';

abstract class PhoneMessageState extends Equatable {
  const PhoneMessageState();

  @override
  List<Object> get props => [];
}

class MessageLoad extends PhoneMessageState {}

class MessageInit extends PhoneMessageState {}

class MessageListEmpty extends PhoneMessageState {}

class MessageGetListError extends PhoneMessageState {}

class MessageSend extends PhoneMessageState {}

class MessageNotSend extends PhoneMessageState {}

class MessageList extends PhoneMessageState {
  final List<Message> messages;
  final String userId;

  const MessageList({required this.messages, required this.userId});

  @override
  List<Object> get props => [messages, userId];
}
