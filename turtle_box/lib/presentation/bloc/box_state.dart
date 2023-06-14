import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/device.dart';

abstract class BoxState extends Equatable {
  const BoxState();

  @override
  List<Object> get props => [];
}

//class BoxStart extends BoxState{}

class BoxEnded extends BoxState {}

class BoxInit extends BoxState {}

class BoxTimeOut extends BoxState {}

class BoxTimeOutStop extends BoxState {}

class BoxNewMessage extends BoxState {}

class BoxEventNext extends BoxState {
  final DateTime time;

  const BoxEventNext({required this.time});

  @override
  List<Object> get props => [time];
}

class BoxStart extends BoxState {
  final String ip;

  const BoxStart({required this.ip});

  @override
  List<Object> get props => [ip];
}

class BoxSecurityWords extends BoxState {
  final String words;

  const BoxSecurityWords({required this.words});

  @override
  List<Object> get props => [words];
}

class BoxSecurityWordsFalse extends BoxState {}

class BoxSecurityWordsGood extends BoxState {}

class BoxDiaporama extends BoxState {
  final Turtle actualDevice;

  const BoxDiaporama({required this.actualDevice});

  @override
  List<Object> get props => [actualDevice];
}

class BoxDiapoNext extends BoxState {}

class BoxShowChoices extends BoxState {
  final Turtle actualDevice;

  const BoxShowChoices({required this.actualDevice});

  @override
  List<Object> get props => [actualDevice];
}
