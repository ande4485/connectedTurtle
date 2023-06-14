import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:mockito/mockito.dart';
import 'package:turtle_box/data/communication/box_turtle_com_impl.dart';
import 'package:turtle_box/domain/config/box_config.dart';
import 'package:turtle_box/domain/password_generator/password_generator.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/main.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_message_bloc.dart';
import 'package:turtle_package/data/communication/socket/phone_box_socket_state.dart';
import 'package:turtle_package/data/communication/socket/socket_client.dart';
import 'package:turtle_package/data/communication/socket/socket_server.dart';
import 'package:turtle_package/domain/repository/auth_repository.dart';

import 'package:turtle_package/domain/repository/box_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/usecase/box_message_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';

import '../../content_test/content_test.dart';
import '../../content_test/method_test.dart';
import '../../mock/generate_mock.mocks.dart';
import '../../utils/maketestable_widget.dart';

void main() {
  final iD = GetIt.instance;
  late BoxConfiguration boxConfig;
  late MockBoxRepository boxRepo;

  late MockAuthRepository authRepository;
  late BoxMessageUseCase messageUseCase;
  late MockMessageRepository messRepo;
  late MockDeviceRepository deviceRepository;
  late BoxMessageBloc boxMessageBloc;
  late PasswordGenerator passwordGenerator;
  late Stream smartphoneCtrlerStream;
  late SocketClient socketSmartphone;
  tearDown(() async {
    await socketSmartphone.disconnect();
    await iD.reset();
  });

  setUp(() {
    boxConfig = MockBoxConfiguration();
    authRepository = MockAuthRepository();
    boxRepo = MockBoxRepository();
    passwordGenerator = MockPasswordGenerator();
    messRepo = MockMessageRepository();
    deviceRepository = MockDeviceRepository();

    iD.registerFactory<MessageRepository>(() => messRepo);
    iD.registerLazySingleton<DeviceRepository>(() => deviceRepository);
    iD.registerLazySingleton<AuthRepository>(() => authRepository);
    iD.registerLazySingleton<BoxConfiguration>(() => boxConfig);
    iD.registerLazySingleton<BoxRepository>(() => boxRepo);
    iD.registerLazySingleton<PasswordGenerator>(() => passwordGenerator);

    iD.registerLazySingleton<BoxUseCase>(() => BoxUseCase(
          authRepository: iD(),
          deviceRepository: iD(),
          messageRepository: iD(),
          boxCommunication: BoxComImpl(socketServer: SocketServer()),
          boxConfig: iD(),
          boxRepository: iD(),
          passwordGenerator: iD(),
        ));
    //boxBloc = ;
    iD.registerLazySingleton<BoxBloc>(() => BoxBloc(boxUseCase: iD()));
    messageUseCase = BoxMessageUseCase(messageRepository: iD());
    iD.registerLazySingleton<BoxMessageUseCase>(() => messageUseCase);
    boxMessageBloc = BoxMessageBloc(messageUseCase: iD());
    iD.registerLazySingleton<BoxMessageBloc>(() => boxMessageBloc);

    when(boxConfig.getIp()).thenAnswer((_) async {
      return '127.0.0.1';
    });

    when(boxRepo.getEmail()).thenAnswer((_) {
      return "test@test.com";
    });
    when(boxRepo.getPassword()).thenAnswer((_) {
      return "passwordtest";
    });
    when(authRepository.signIn("test@test.com", "passwordtest"))
        .thenAnswer((_) async {
      return AuthDeviceUser(id: "1");
    });

    when(passwordGenerator.generatePassword())
        .thenAnswer((realInvocation) => 'ABCDE');
    when(passwordGenerator.getLastPassword())
        .thenAnswer((realInvocation) => 'ABCDE');
    socketSmartphone = SocketClient();
  });

  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test normal smartphone connection add turtle',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );
    smartphoneCtrlerStream =
        socketSmartphone.listenBoxEvent().asBroadcastStream();
    await checkStartBox(tester);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    socketSmartphone.connect('127.0.0.1');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(smartphoneCtrlerStream, emits(BoxAskPassword()));
    //normally we have a password to display on tv screen
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsOneWidget);
    socketSmartphone.sendPassword("ABCDE");
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text(S.current.accepted_phone), findsOneWidget);
    await socketSmartphone.isConfig();
    expect(smartphoneCtrlerStream, emits(BoxSocketIsConfig(idBox: '1234')));
    await socketSmartphone.addTurtle(turtle1);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    verify(boxRepo.addTurtle(any)).called(1);
  });

  testWidgets('test normal smartphone connection add emergency',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );
    smartphoneCtrlerStream =
        socketSmartphone.listenBoxEvent().asBroadcastStream();
    await checkStartBox(tester);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    socketSmartphone.connect('127.0.0.1');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(smartphoneCtrlerStream, emits(BoxAskPassword()));
    //normally we have a password to display on tv screen
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsOneWidget);
    socketSmartphone.sendPassword("ABCDE");
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text(S.current.accepted_phone), findsOneWidget);
    await socketSmartphone.isConfig();
    expect(smartphoneCtrlerStream, emits(BoxSocketIsConfig(idBox: '1234')));
    await socketSmartphone.addEmergency(emergency1);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    verify(boxRepo.addEmergency(any)).called(1);
  });

  testWidgets('test error smartphone connection', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );
    var errorConnection = false;
    await checkStartBox(tester);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    socketSmartphone.connect('127.0.0.1');

    await tester.pumpAndSettle(const Duration(seconds: 2));
    //normally we have a password to display on tv screen
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsOneWidget);
    socketSmartphone.sendPassword("ABCD");
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text(S.current.wrong_password), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    try {
      await socketSmartphone.isConfig();
    } catch (e) {
      print("error close");
      errorConnection = true;
    }

    expect(errorConnection, true);
  });
}
