import 'dart:typed_data';

abstract class RemoteDownloadDataSource {
  Future<Uint8List> downloadImages(String pathImages);

  Future<Uint8List> downloadVideos(String pathVideos);

  Future<Uint8List> downloadSound(String pathSound);
}
