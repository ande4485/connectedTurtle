import 'dart:typed_data';

import 'package:turtle_package/domain/repository/download_repository.dart';

class DownloadUseCase {
  final DownloadRepository downloadRepository;

  DownloadUseCase({required this.downloadRepository});

  Future<Uint8List> downloadVideo(String idVideo) {
    return downloadRepository.downloadVideos(idVideo);
  }

  Future<Uint8List> downloadImage(String idImage) {
    return downloadRepository.downloadImages(idImage);
  }

  Future<Uint8List> downloadSound(String idSound) {
    return downloadRepository.downloadSound(idSound);
  }
}
