import 'package:mockito/annotations.dart';
import 'package:turtle_package/data/remote/remote_auth_datasource.dart';
import 'package:turtle_package/data/remote/remote_device_datasource.dart';
import 'package:turtle_package/data/remote/remote_device_users_datasource.dart';
import 'package:turtle_package/data/remote/remote_message_datasource.dart';

import 'package:turtle_package/domain/repository/auth_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/device_user_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/domain/usecase/device_usecase.dart';
import 'package:turtle_package/domain/usecase/device_user_usecase.dart';
import 'package:turtle_phone/domain/communication/phone_box_com.dart';
import 'package:turtle_phone/domain/communication/phone_turtle_com.dart';
import 'package:turtle_phone/domain/config/wifi_information.dart';
import 'package:turtle_phone/domain/usecase/init_phone_usecase.dart';
import 'package:turtle_phone/domain/usecase/phone_message_usecase.dart';
import 'package:turtle_phone/domain/usecase/sound_phone_usecase.dart';

import 'package:turtle_phone/presentation/bloc/device_bloc.dart';
import 'package:turtle_phone/presentation/bloc/device_users_bloc.dart';
import 'package:turtle_phone/presentation/bloc/init_device_bloc.dart';
import 'package:turtle_phone/presentation/bloc/phone_message_bloc.dart';
import 'package:turtle_phone/presentation/bloc/sound_phone_bloc.dart';
import 'package:turtle_phone/presentation/bloc/user_bloc.dart';

@GenerateMocks([
  PhoneMessageBloc,
  DeviceBloc,
  DeviceUsersBloc,
  UserBloc,
  InitDeviceBloc,
  SoundPhoneBloc,
  PhoneMessageUseCase,
  DeviceUseCase,
  DeviceUsersUseCase,
  SoundPhoneUseCase,
  InitPhoneUseCase,
  AuthRepository,
  MessageRepository,
  DeviceRepository,
  DeviceUsersRepository,
  PhoneDeviceCommunication,
  PhoneBoxCommunication,
  RemoteAuthDataSource,
  RemoteMessageDataSource,
  RemoteDeviceDataSource,
  RemoteDeviceUsersDataSource,
  SoundApi,
  WifiInformation
])
generateMock() {}
