import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/message.dart';

abstract class DiapoState extends Equatable {
  const DiapoState();

  @override
  List<Object> get props => [];
}

class DiapoInit extends DiapoState {}

class DiapoStart extends DiapoState {}

class DiapoEnd extends DiapoState {}

class DiapoShowText extends DiapoState {
  final TextMessage actualMessage;

  const DiapoShowText({required this.actualMessage});

  @override
  List<Object> get props => [actualMessage];
}

class DiapoShowImage extends DiapoState {
  final ImageMessage actualMessage;

  const DiapoShowImage({required this.actualMessage});

  @override
  List<Object> get props => [actualMessage];
}

class DiapoShowVideo extends DiapoState {
  final VideoMessage actualMessage;

  const DiapoShowVideo({required this.actualMessage});

  @override
  List<Object> get props => [actualMessage];
}

class DiapoShowYoutubeVideo extends DiapoState {
  final YoutubeMessage actualMessage;

  const DiapoShowYoutubeVideo({required this.actualMessage});

  @override
  List<Object> get props => [actualMessage];
}

class DiapoShowVocalRecorder extends DiapoState {
  final Message actualMessage;

  const DiapoShowVocalRecorder({required this.actualMessage});

  @override
  List<Object> get props => [actualMessage];
}
