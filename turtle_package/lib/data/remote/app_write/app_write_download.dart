import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:turtle_package/data/remote/app_write/app_write_config.dart';
import 'package:turtle_package/data/remote/remote_download_datasource.dart';

class AppWriteDownload extends RemoteDownloadDataSource {
  final Storage storage;

  AppWriteDownload({required this.storage});

  @override
  Future<Uint8List> downloadImages(String pathImage) async {
    return await storage.getFileView(
        bucketId: BUCKET_IMAGE_ID, fileId: pathImage);
  }

  @override
  Future<Uint8List> downloadSound(String pathSound) async {
    return await storage.getFileDownload(
        bucketId: BUCKET_IMAGE_ID, fileId: pathSound);
  }

  @override
  Future<Uint8List> downloadVideos(String pathVideo) async {
    return await storage.getFileDownload(
        bucketId: BUCKET_VIDEO_ID, fileId: pathVideo);
  }
}
