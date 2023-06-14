import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:turtle_package/domain/usecase/download_usecase.dart';

import 'download_state.dart';

class DownloadBloc extends Cubit<DownloadState> {
  final DownloadUseCase downloadUseCase;
  Uint8List? data;
  final String idFile;
  DownloadBloc({required this.downloadUseCase, required this.idFile})
      : super(DownloadInit(id: idFile));

  Future<void> videoDownload() async {
    emit(DownloadingVideo(id: idFile));
    try {
      data = await downloadUseCase.downloadVideo(idFile);
      emit(DownloadedVideo(data: data!, id: idFile));
    } catch (e) {
      emit(DownloadingVideoError(id: idFile));
    }
  }

  Future<void> imageDownload() async {
    emit(DownloadingImage(id: idFile));
    try {
      data = await downloadUseCase.downloadImage(idFile);
      emit(DownloadedImage(data: data!, id: idFile));
    } catch (e) {
      emit(DownloadingImageError(id: idFile));
    }
  }

  Future<void> soundDownload() async {
    emit(DownloadingSound(id: idFile));

    try {
      data = await downloadUseCase.downloadSound(idFile);
      emit(DownloadedSound(data: data!, id: idFile));
    } catch (e) {
      emit(DownloadingSoundError(id: idFile));
    }
  }
}
