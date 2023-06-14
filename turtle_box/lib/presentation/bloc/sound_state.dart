import 'package:equatable/equatable.dart';

abstract class SoundState extends Equatable {
  const SoundState();

  @override
  List<Object> get props => [];
}

class SoundInit extends SoundState {}

class SoundError extends SoundState {}
