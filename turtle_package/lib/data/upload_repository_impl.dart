import 'dart:io';

import 'dart:typed_data';

import 'package:turtle_package/data/remote/remote_upload_datasource.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

class UploadRepositoryImpl extends UploadRepository {
  final RemoteUploadDatasource remoteUploadDatasource;

  UploadRepositoryImpl({required this.remoteUploadDatasource});

  @override
  Future<List<String>> uploadImagesDatas(
      List<Uint8List> imagesPath, String idDevice) {
    return remoteUploadDatasource.uploadImagesDatas(imagesPath, idDevice);
  }

  @override
  Future<List<String>> uploadImagesFiles(
      List<File> imagesPath, String idDevice) {
    return remoteUploadDatasource.uploadImagesFiles(imagesPath, idDevice);
  }

  @override
  Future<String> uploadSoundDatas(List<int> soundPath, String idDevice) {
    return remoteUploadDatasource.uploadSoundDatas(soundPath, idDevice);
  }

  @override
  Future<List<String>> uploadVideosDatas(
      List<Uint8List> videosPath, String idDevice) {
    return remoteUploadDatasource.uploadVideosDatas(videosPath, idDevice);
  }

  @override
  Future<List<String>> uploadVideosFiles(
      List<File> videosPath, String idDevice) {
    return remoteUploadDatasource.uploadVideosFiles(videosPath, idDevice);
  }
}
