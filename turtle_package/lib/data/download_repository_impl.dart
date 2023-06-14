import 'dart:typed_data';

import 'package:turtle_package/data/remote/remote_download_datasource.dart';
import 'package:turtle_package/domain/repository/download_repository.dart';

class DownloadRepositoryImpl extends DownloadRepository {
  final RemoteDownloadDataSource remoteDownloadDataSource;

  DownloadRepositoryImpl({required this.remoteDownloadDataSource});

  @override
  Future<Uint8List> downloadImages(String pathImages) {
    return remoteDownloadDataSource.downloadImages(pathImages);
  }

  @override
  Future<Uint8List> downloadSound(String pathSound) {
    return remoteDownloadDataSource.downloadSound(pathSound);
  }

  @override
  Future<Uint8List> downloadVideos(String pathVideos) {
    return remoteDownloadDataSource.downloadVideos(pathVideos);
  }
}
