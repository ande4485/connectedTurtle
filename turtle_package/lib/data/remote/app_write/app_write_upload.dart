import 'dart:io';

import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as AppWriteFile;
import 'package:turtle_package/data/remote/app_write/app_write_config.dart';
import 'package:turtle_package/data/remote/remote_upload_datasource.dart';

class AppWriteUpload extends RemoteUploadDatasource {
  final Storage storage;

  AppWriteUpload({required this.storage});

  @override
  Future<List<String>> uploadImagesDatas(
      List<Uint8List> imagesPath, String idDevice) async {
    List<String> pathNames = [];
    for (Uint8List imagePath in imagesPath) {
      var id = ID.unique();
      AppWriteFile.File file = await storage.createFile(
          bucketId: BUCKET_IMAGE_ID,
          fileId: id,
          permissions: permissions(idDevice),
          file: InputFile.fromBytes(bytes: imagePath, filename: id));
      pathNames.add(file.$id);
    }
    return pathNames;
  }

  List<String> permissions(String idDevice) {
    List<String> permissions = [];
    permissions.add(Permission.write(Role.team(idDevice)));
    permissions.add(Permission.read(Role.team(idDevice)));
    permissions.add(Permission.update(Role.team(idDevice)));
    return permissions;
  }

  @override
  Future<List<String>> uploadImagesFiles(
      List<File> imagesPath, String idDevice) async {
    List<String> pathNames = [];
    for (File imagePath in imagesPath) {
      String id = ID.unique();
      var extension = imagePath.path.split('/');
      AppWriteFile.File file = await storage.createFile(
          bucketId: BUCKET_IMAGE_ID,
          fileId: id,
          permissions: permissions(idDevice),
          file: InputFile.fromPath(
              path: imagePath.path, filename: extension.last));
      pathNames.add(file.$id);
    }
    return pathNames;
  }

  @override
  Future<String> uploadSoundDatas(List<int> soundPath, String idDevice) async {
    var id = ID.unique();

    AppWriteFile.File file = await storage.createFile(
        bucketId: BUCKET_SOUND_ID,
        fileId: id,
        permissions: permissions(idDevice),
        file: InputFile.fromBytes(bytes: soundPath, filename: id));

    return file.$id;
  }

  @override
  Future<List<String>> uploadVideosDatas(
      List<Uint8List> videosPath, String idDevice) async {
    List<String> pathNames = [];
    for (Uint8List imagePath in videosPath) {
      var id = ID.unique();
      AppWriteFile.File file = await storage.createFile(
          bucketId: BUCKET_VIDEO_ID,
          fileId: id,
          permissions: permissions(idDevice),
          file: InputFile.fromBytes(bytes: imagePath, filename: id));
      pathNames.add(file.$id);
    }
    return pathNames;
  }

  @override
  Future<List<String>> uploadVideosFiles(
      List<File> videosPath, String idDevice) async {
    List<String> pathNames = [];
    for (File imagePath in videosPath) {
      var id = ID.unique();
      var extension = imagePath.path.split('/');
      AppWriteFile.File file = await storage.createFile(
          bucketId: BUCKET_VIDEO_ID,
          fileId: id,
          permissions: permissions(idDevice),
          file: InputFile.fromPath(
              path: imagePath.path, filename: extension.last));
      pathNames.add(file.$id);
    }
    return pathNames;
  }
}
