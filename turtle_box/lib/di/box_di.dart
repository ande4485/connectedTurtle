import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turtle_box/data/box_repository_impl.dart';
import 'package:turtle_box/data/communication/box_turtle_com_impl.dart';
import 'package:turtle_box/data/internal/config/local_box_config.dart';
import 'package:turtle_box/data/internal/sharedpreferences/box_shared_preferences.dart';
import 'package:turtle_box/data/password_generator/password_generator.dart';
import 'package:turtle_box/domain/communication/box_turtle_com.dart';
import 'package:turtle_box/domain/config/box_config.dart';
import 'package:turtle_box/domain/password_generator/password_generator.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';
import 'package:turtle_box/domain/usecase/sound_box_usecase.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_message_bloc.dart';
import 'package:turtle_box/presentation/bloc/sound_box_bloc.dart';
import 'package:turtle_package/data/auth_reporsitorty_impl.dart';
import 'package:turtle_package/data/communication/socket/socket_server.dart';
import 'package:turtle_package/data/device_repository_impl.dart';
import 'package:turtle_package/data/download_repository_impl.dart';

import 'package:turtle_package/data/internal/sound/sound_impl.dart';
import 'package:turtle_package/data/message_repository_impl.dart';
import 'package:turtle_package/data/remote/app_write/app_write_auth.dart';
import 'package:turtle_package/data/remote/app_write/app_write_device.dart';
import 'package:turtle_package/data/remote/app_write/app_write_download.dart';
import 'package:turtle_package/data/remote/app_write/app_write_message.dart';
import 'package:turtle_package/data/remote/app_write/app_write_upload.dart';

import 'package:turtle_package/data/remote/remote_auth_datasource.dart';
import 'package:turtle_package/data/remote/remote_device_datasource.dart';
import 'package:turtle_package/data/remote/remote_download_datasource.dart';
import 'package:turtle_package/data/remote/remote_message_datasource.dart';
import 'package:turtle_package/data/remote/remote_upload_datasource.dart';

import 'package:turtle_package/data/upload_repository_impl.dart';

import 'package:turtle_package/domain/repository/auth_repository.dart';
import 'package:turtle_package/domain/repository/box_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/download_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';

import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/domain/usecase/box_message_usecase.dart';
import 'package:turtle_package/domain/usecase/device_usecase.dart';
import 'package:turtle_package/presentation/bloc/auth_bloc.dart';

final iD = GetIt.instance;

Future<void> init() async {
  //Blocs
  iD.registerFactory(
    () => AuthBloc(
      authUseCase: iD(),
    ),
  );

  iD.registerFactory(
    () => BoxMessageBloc(
      messageUseCase: iD(),
    ),
  );

  iD.registerLazySingleton(
    () => BoxBloc(
      boxUseCase: iD(),
    ),
  );

  iD.registerFactory(
    () => SoundBoxBloc(
      soundUseCase: iD(),
    ),
  );

//Use cases

  iD.registerLazySingleton(() => AuthUseCase(repository: iD()));
  iD.registerLazySingleton(() => BoxMessageUseCase(messageRepository: iD()));
  iD.registerLazySingleton(() => DeviceUseCase(repository: iD()));
  iD.registerLazySingleton(() => BoxUseCase(
      authRepository: iD(),
      boxConfig: iD(),
      boxRepository: iD(),
      messageRepository: iD(),
      deviceRepository: iD(),
      boxCommunication: iD(),
      passwordGenerator: iD()));
  iD.registerLazySingleton(() => SoundBoxUseCase(
      boxMessageRepository: iD(), soundApi: iD(), uploadRepository: iD()));
  //Repository
  //Repositories
  iD.registerLazySingleton<BoxRepository>(
    () => BoxRepositoryImpl(
      boxSharedPreferences: iD(),
    ),
  );

  iD.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(remoteUploadDatasource: iD()),
  );

  iD.registerLazySingleton<DownloadRepository>(
    () => DownloadRepositoryImpl(remoteDownloadDataSource: iD()),
  );

  iD.registerFactory<SoundApi>(
    () => SoundImpl(),
  );

  iD.registerLazySingleton<BoxConfiguration>(
    () => LocalBoxConfig(),
  );
  iD.registerLazySingleton<BoxCommunication>(
    () => BoxComImpl(socketServer: iD()),
  );

  iD.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteAuthDataSource: iD(),
    ),
  );

  iD.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(
      remoteMessageDataSource: iD(),
    ),
  );

  iD.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      remoteDeviceDataSource: iD(),
    ),
  );

//DATA sources

  iD.registerLazySingleton<PasswordGenerator>(
    () => PasswordGeneratorImpl(),
  );
  iD.registerLazySingleton(() => BoxSharedPreferences(sharedPreferences: iD()));

  iD.registerLazySingleton(() => SocketServer());
  iD.registerLazySingleton<RemoteAuthDataSource>(
    () => AppWriteAuth(account: iD()),
  );

  iD.registerLazySingleton<RemoteDownloadDataSource>(
    () => AppWriteDownload(storage: iD()),
  );

  iD.registerLazySingleton<RemoteUploadDatasource>(
    () => AppWriteUpload(storage: iD()),
  );
  iD.registerLazySingleton<RemoteMessageDataSource>(
    () => AppWriteMessage(appWriteDatabase: iD(), realtime: iD()),
  );

  iD.registerLazySingleton<RemoteDeviceDataSource>(
    () => AppWriteDevice(appDatabase: iD(), teams: iD()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  iD.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  Client client = Client();
  iD.registerLazySingleton(() => Account(client));
  iD.registerLazySingleton(() => Teams(client));
  iD.registerLazySingleton(() => Databases(client));
  iD.registerLazySingleton(() => Storage(client));
  iD.registerLazySingleton(() => Realtime(client));
}
