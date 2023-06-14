import 'dart:io';

import 'dart:typed_data';

abstract class RemoteUploadDatasource {
  Future<List<String>> uploadImagesDatas(
      List<Uint8List> imagesPath, String idDevice);

  Future<List<String>> uploadImagesFiles(
      List<File> imagesPath, String idDevice);

  Future<String> uploadSoundDatas(List<int> soundPath, String idDevice);

  Future<List<String>> uploadVideosDatas(
      List<Uint8List> videosPath, String idDevice);

  Future<List<String>> uploadVideosFiles(
      List<File> videosPath, String idDevice);
}
