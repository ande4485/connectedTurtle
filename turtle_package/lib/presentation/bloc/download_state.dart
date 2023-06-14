import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class DownloadState extends Equatable {
  final String id;
  DownloadState({required this.id});

  @override
  List<Object> get props => [id];
}

class DownloadInit extends DownloadState {
  DownloadInit({required super.id});
}

class DownloadingVideo extends DownloadState {
  DownloadingVideo({required super.id});
}

class DownloadedVideo extends DownloadState {
  final Uint8List data;

  DownloadedVideo({required this.data, required super.id});

  @override
  List<Object> get props => [data];
}

class DownloadingVideoError extends DownloadState {
  DownloadingVideoError({required super.id});
}

class DownloadingImage extends DownloadState {
  DownloadingImage({required super.id});
}

class DownloadedImage extends DownloadState {
  final Uint8List data;

  DownloadedImage({required this.data, required super.id});

  @override
  List<Object> get props => [data];
}

class DownloadingImageError extends DownloadState {
  DownloadingImageError({required super.id});
}

class DownloadingSound extends DownloadState {
  DownloadingSound({required super.id});
}

class DownloadedSound extends DownloadState {
  final Uint8List data;

  DownloadedSound({required this.data, required super.id});

  @override
  List<Object> get props => [data];
}

class DownloadingSoundError extends DownloadState {
  DownloadingSoundError({required super.id});
}
