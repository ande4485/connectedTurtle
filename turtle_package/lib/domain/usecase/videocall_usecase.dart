import 'package:turtle_package/domain/videocall/videocall_api.dart';

class VideoCallUseCase{

  final VideoCallApi videoCallApi;

  VideoCallUseCase({required this.videoCallApi} );


  Future<void> startVideoCall(){
    return videoCallApi.startVideoCall();
  }

  Future<void> stopVideoCall(){
    return videoCallApi.stopVideoCall();
  }

  Future<void> acceptVideoCall(){
    return videoCallApi.acceptVideoCall();
  }




}