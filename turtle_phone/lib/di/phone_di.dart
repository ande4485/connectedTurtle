import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

import 'package:turtle_package/data/auth_reporsitorty_impl.dart';
import 'package:turtle_package/data/box_create_repository_impl.dart';
import 'package:turtle_package/data/device_repository_impl.dart';
import 'package:turtle_package/data/device_user_repository_impl.dart';
import 'package:turtle_package/data/download_repository_impl.dart';

import 'package:turtle_package/data/internal/sound/sound_impl.dart';
import 'package:turtle_package/data/message_repository_impl.dart';
import 'package:turtle_package/data/remote/app_write/app_write_auth.dart';
import 'package:turtle_package/data/remote/app_write/app_write_config.dart';
import 'package:turtle_package/data/remote/app_write/app_write_create_box.dart';
import 'package:turtle_package/data/remote/app_write/app_write_device.dart';
import 'package:turtle_package/data/remote/app_write/app_write_device_users.dart';
import 'package:turtle_package/data/remote/app_write/app_write_download.dart';
import 'package:turtle_package/data/remote/app_write/app_write_message.dart';

import 'package:turtle_package/data/remote/app_write/app_write_upload.dart';

import 'package:turtle_package/data/remote/remote_auth_datasource.dart';
import 'package:turtle_package/data/remote/remote_device_datasource.dart';
import 'package:turtle_package/data/remote/remote_device_users_datasource.dart';
import 'package:turtle_package/data/remote/remote_download_datasource.dart';
import 'package:turtle_package/data/remote/remote_message_datasource.dart';

import 'package:turtle_package/data/remote/remote_upload_datasource.dart';

import 'package:turtle_package/data/upload_repository_impl.dart';

import 'package:turtle_package/domain/repository/auth_repository.dart';
import 'package:turtle_package/domain/repository/box_create_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/device_user_repository.dart';
import 'package:turtle_package/domain/repository/download_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/domain/usecase/device_usecase.dart';
import 'package:turtle_package/domain/usecase/device_user_usecase.dart';
import 'package:turtle_package/domain/usecase/download_usecase.dart';
import 'package:turtle_package/presentation/bloc/download_files_bloc.dart';

import '../data/communication/bluetooth/bluetooth_communication.dart';
import '../data/communication/phone_turtle_communication_impl.dart';
import '../data/communication/socket/phone_box_com_impl.dart';
import '../data/internal/wifi_info.dart';
import '../domain/communication/phone_box_com.dart';
import '../domain/communication/phone_turtle_com.dart';
import '../domain/config/wifi_information.dart';
import '../domain/usecase/init_phone_usecase.dart';
import '../domain/usecase/phone_message_usecase.dart';
import '../domain/usecase/sound_phone_usecase.dart';

import '../presentation/bloc/device_bloc.dart';
import '../presentation/bloc/device_users_bloc.dart';
import '../presentation/bloc/init_device_bloc.dart';
import '../presentation/bloc/login_bloc.dart';
import '../presentation/bloc/phone_message_bloc.dart';
import '../presentation/bloc/sound_phone_bloc.dart';
import '../presentation/bloc/user_bloc.dart';

final iD = GetIt.instance;

Future<void> init() async {
  //Blocs
  iD.registerFactory(
    () => LoginBloc(authUseCase: iD(), userUseCase: iD()),
  );

  iD.registerFactoryParam<PhoneMessageBloc, String, String>(
    (param1, param2) => PhoneMessageBloc(
        messageUseCase: iD(),
        turtleId: param1,
        authUseCase: iD(),
        userNameForTurtle: param2),
  );

  iD.registerFactory(
    () => DeviceBloc(deviceUseCase: iD(), authUseCase: iD()),
  );

  iD.registerFactory(
    () => DeviceUsersBloc(deviceUsersUseCase: iD(), authUseCase: iD()),
  );

  iD.registerFactory(
    () => UserBloc(userUseCase: iD(), authUsecase: iD()),
  );
  iD.registerFactory(
    () => InitDeviceBloc(
      initPhoneUseCase: iD(),
    ),
  );

  iD.registerFactoryParam<DownloadBloc, String, void>(
      (param1, param2) => DownloadBloc(downloadUseCase: iD(), idFile: param1));

  iD.registerFactory(
    () => SoundPhoneBloc(
      soundUseCase: iD(),
    ),
  );
//Use cases

  iD.registerLazySingleton(() => AuthUseCase(repository: iD()));

  iD.registerLazySingleton(() =>
      PhoneMessageUseCase(messageRepository: iD(), uploadRepository: iD()));
  iD.registerLazySingleton(() => DeviceUseCase(repository: iD()));
  iD.registerLazySingleton(() => DeviceUsersUseCase(repository: iD()));
  iD.registerLazySingleton(() => SoundPhoneUseCase(soundApi: iD()));
  iD.registerFactory(() => InitPhoneUseCase(
      phoneDeviceCommunication: iD(),
      phoneBoxCommunication: iD(),
      wifiInformation: iD(),
      deviceRepository: iD(),
      boxCreateRepository: iD()));

  iD.registerFactory(() => DownloadUseCase(downloadRepository: iD()));

  //Repository
  //Repositories

  iD.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteAuthDataSource: iD(),
    ),
  );

  iD.registerLazySingleton<WifiInformation>(
    () => WifiInfo(),
  );

  iD.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(
      remoteMessageDataSource: iD(),
    ),
  );

  iD.registerLazySingleton<DownloadRepository>(
      () => DownloadRepositoryImpl(remoteDownloadDataSource: iD()));

  iD.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(
      remoteUploadDatasource: iD(),
    ),
  );

  iD.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      remoteDeviceDataSource: iD(),
    ),
  );

  iD.registerLazySingleton<DeviceUsersRepository>(
    () => DeviceUserRepositoryImpl(
      remoteDeviceUserDataSource: iD(),
    ),
  );

  iD.registerLazySingleton<BoxCreateRepository>(
      () => BoxCreateRepositoryImpl(remoteBoxCreateDataSource: iD()));

  iD.registerFactory<PhoneDeviceCommunication>(
    () => PhoneDeviceCommunicationImpl(
      bluetoothCommunication: BluetoothCommunication(),
    ),
  );

  iD.registerFactory<PhoneBoxCommunication>(
    () => PhoneBoxComImpl(),
  );

//DATA sources

  iD.registerLazySingleton<RemoteAuthDataSource>(
    () => AppWriteAuth(account: iD()),
  );

  iD.registerLazySingleton<RemoteMessageDataSource>(
      () => AppWriteMessage(appWriteDatabase: iD(), realtime: iD()));

  iD.registerLazySingleton<RemoteDeviceDataSource>(
    () => AppWriteDevice(teams: iD(), appDatabase: iD()),
  );

  iD.registerLazySingleton<RemoteDeviceUsersDataSource>(
    () => AppWriteDeviceUsers(realtime: iD(), teams: iD(), account: iD()),
  );

  iD.registerLazySingleton<RemoteUploadDatasource>(
    () => AppWriteUpload(storage: iD()),
  );

  iD.registerLazySingleton<RemoteDownloadDataSource>(
    () => AppWriteDownload(storage: iD()),
  );

  iD.registerFactory<SoundApi>(
    () => SoundImpl(),
  );

  iD.registerLazySingleton(() => AppWriteCreateBox(accountAdmin: iD()));

  Client client = Client(endPoint: ENDPOINT);
  client.setProject(PROJECT_ID);
  iD.registerLazySingleton(() => Account(client));
  iD.registerLazySingleton(() => Realtime(client));
  iD.registerLazySingleton(() => Teams(client));
  iD.registerLazySingleton(() => Databases(client));
  iD.registerLazySingleton(() => Storage(client));
}
