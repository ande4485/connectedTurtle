import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:mockito/mockito.dart';
import 'package:turtle_box/domain/communication/box_turtle_com.dart';
import 'package:turtle_box/domain/config/box_config.dart';
import 'package:turtle_box/domain/password_generator/password_generator.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';
import 'package:turtle_box/main.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_message_bloc.dart';
import 'package:turtle_package/data/communication/socket/box_socket_state.dart';

import 'package:turtle_package/domain/repository/auth_repository.dart';

import 'package:turtle_package/domain/repository/box_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/usecase/box_message_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

import '../../content_test/content_test.dart';
import '../../mock/generate_mock.mocks.dart';
import '../../utils/maketestable_widget.dart';

void main() {
  final iD = GetIt.instance;
  late BoxCommunication boxCom;
  late BoxConfiguration boxConfig;
  late MockBoxRepository boxRepo;
  late MockMessageRepository messRepo;
  late MockDeviceRepository deviceRepository;
  late BoxBloc boxBloc;
  late MockAuthRepository authRepository;
  late BoxMessageUseCase messageUseCase;
  late BoxUseCase boxUseCase;
  late BoxMessageBloc boxMessageBloc;
  late PasswordGenerator passwordGenerator;
  late StreamController<BoxSocketState> turtleEvent;
  late StreamController<List<Message>> messageEvent;
  int nbMessage = 3;

  //final mockObserver = MockNavigatorObserver();

  tearDown(() async {
    await turtleEvent.close();
    await messageEvent.close();
    await iD.reset();
  });

  setUp(() {
    turtleEvent = StreamController<BoxSocketState>();
    messageEvent = StreamController<List<Message>>();
    boxCom = MockBoxCommunication();
    boxConfig = MockBoxConfiguration();
    boxRepo = MockBoxRepository();
    messRepo = MockMessageRepository();
    deviceRepository = MockDeviceRepository();
    authRepository = MockAuthRepository();
    passwordGenerator = MockPasswordGenerator();
    iD.registerLazySingleton<BoxCommunication>(() => boxCom);
    iD.registerLazySingleton<AuthRepository>(() => authRepository);
    iD.registerFactory<MessageRepository>(() => messRepo);

    iD.registerLazySingleton<BoxRepository>(() => boxRepo);
    iD.registerLazySingleton<DeviceRepository>(() => deviceRepository);
    iD.registerLazySingleton<BoxConfiguration>(() => boxConfig);
    iD.registerLazySingleton<PasswordGenerator>(() => passwordGenerator);
    boxUseCase = BoxUseCase(
      authRepository: iD(),
      deviceRepository: iD(),
      messageRepository: iD(),
      boxCommunication: iD(),
      boxConfig: iD(),
      boxRepository: iD(),
      passwordGenerator: iD(),
    );
    iD.registerLazySingleton<BoxUseCase>(() => boxUseCase);
    when(boxConfig.getIp()).thenAnswer((_) async {
      return '127.0.0.1';
    });
    boxBloc = BoxBloc(boxUseCase: iD());
    iD.registerLazySingleton<BoxBloc>(() => boxBloc);
    messageUseCase = BoxMessageUseCase(messageRepository: iD());
    iD.registerLazySingleton<BoxMessageUseCase>(() => messageUseCase);
    boxMessageBloc = BoxMessageBloc(messageUseCase: iD());
    iD.registerLazySingleton<BoxMessageBloc>(() => boxMessageBloc);

    when(boxRepo.getEmail()).thenAnswer((_) {
      return "test@test.com";
    });
    when(boxRepo.getPassword()).thenAnswer((_) {
      return "passwordtest";
    });

    when(deviceRepository.getDevice('1', DeviceType.turtle))
        .thenAnswer((_) async {
      return turtle1;
    });
    when(authRepository.signIn("test@test.com", "passwordtest"))
        .thenAnswer((_) async {
      return AuthDeviceUser(id: "1");
    });
    when(boxCom.listeningDeviceEvent()).thenAnswer((_) {
      return turtleEvent.stream;
    });
    when(messRepo.deviceMessages('1')).thenAnswer((_) {
      return messageEvent.stream;
    });
  });

  /**final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;**/

  testWidgets('test disconnect with one turtle', (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      if (nbMessage == 3) {
        return [
          TextMessage(
              id: '100',
              fromId: '0',
              fromStr: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test text',
              needVocalAnswer: false,
              read: false),
          ImageMessage(
              id: '200',
              fromId: '0',
              fromStr: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test image',
              needVocalAnswer: false,
              read: false,
              isFamily: false,
              link: ['']),
          VideoMessage(
              id: '300',
              fromId: '0',
              fromStr: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test video',
              needVocalAnswer: false,
              read: false,
              link: [''],
              isFamily: false),
          /** YoutubeMessage(
              fromId: '0',
              fromString: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test youtube',
              needVocalAnswer: false,
              read: false, link: 'https://youtu.be/VReCpkav3RY'),**/
        ];
      } else if (nbMessage == 1) {
        return [
          ImageMessage(
              id: '950',
              fromId: '0',
              fromStr: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test image',
              needVocalAnswer: false,
              read: false,
              isFamily: false,
              link: [''])
        ];
      } else {
        return List.empty();
      }
    });
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );

    await tester.pump();

    turtleEvent.add(DeviceConnected(id: '1', deviceType: DeviceType.turtle));
    messageEvent.add(List.filled(
        1,
        TextMessage(
            id: '980',
            fromId: '0',
            fromStr: 'test',
            to: '1',
            date: DateTime.now(),
            message: 'test text',
            needVocalAnswer: false,
            read: false)));
    await tester.pump();
    verify(boxCom.newMessageReceived('1')).called(1);
    await tester.pump();
    await expectLater(find.byKey(const Key("ip_text")), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pump();
    expect(find.text('You received messages'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pump();
    verify(messageUseCase.getNewMessages("1")).called(1);

    await tester.pumpAndSettle();
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test text'), findsOneWidget);

    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messRepo.setMessageRead("1", any)).called(1);
    //so we go to second message image Message
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test image'), findsOneWidget);
    turtleEvent
        .add(DeviceDisconnected(idDevice: '1', deviceType: DeviceType.turtle));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    messageEvent = StreamController<List<Message>>();
    await expectLater(find.byKey(const Key("ip_text")), findsOneWidget);
    nbMessage = 1;
    turtleEvent.add(DeviceConnected(id: '1', deviceType: DeviceType.turtle));
    messageEvent.add(List.filled(
        1,
        TextMessage(
            id: '900',
            fromId: '0',
            fromStr: 'test',
            to: '1',
            date: DateTime.now(),
            message: 'test text',
            needVocalAnswer: false,
            read: false)));
    await tester.pumpAndSettle();
    verify(boxCom.newMessageReceived('1')).called(1);
    await tester.pumpAndSettle();
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    expect(find.text('You received messages'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getNewMessages("1")).called(1);

    //so we go to video message
    nbMessage = 0;
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test image'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messRepo.setMessageRead("1", any)).called(1);
    verify(messageUseCase.getNewMessages("1")).called(1);

    await expectLater(find.byKey(const Key("goodByeText")), findsOneWidget);

    await tester.pump(const Duration(seconds: 12));
    await tester.pump();
  });
}
