import 'package:turtle_box/data/communication/box_turtle_com_impl.dart';
import 'package:turtle_box/domain/communication/box_turtle_com.dart';
import 'package:turtle_box/domain/config/box_config.dart';
import 'package:turtle_box/domain/password_generator/password_generator.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';
import 'package:turtle_box/domain/usecase/sound_box_usecase.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_message_bloc.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:turtle_package/domain/repository/auth_repository.dart';

import 'package:turtle_package/domain/repository/box_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';

import 'package:turtle_package/domain/usecase/box_message_usecase.dart';

@GenerateMocks([
  BoxComImpl,
  BoxBloc,
  AuthRepository,
  DeviceRepository,
  MessageRepository,
  BoxCommunication,
  BoxConfiguration,
  BoxRepository,
  BoxMessageBloc,
  BoxMessageUseCase,
  PasswordGenerator,
  BoxUseCase,
  SoundBoxUseCase,
  SoundApi,
  UploadRepository
])
generateMock() {}
