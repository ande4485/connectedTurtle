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

import '../../mock/generate_mock.mocks.dart';
import '../../utils/maketestable_widget.dart';

void main() {
  final iD = GetIt.instance;
  late BoxCommunication boxCom;
  late BoxConfiguration boxConfig;
  late BoxRepository boxRepo;
  late MockMessageRepository messRepo;
  late DeviceRepository deviceRepository;
  late AuthRepository authRepository;
  late BoxMessageUseCase messageUseCase;
  late BoxMessageBloc boxMessageBloc;
  late PasswordGenerator passwordGenerator;
  late StreamController<BoxSocketState> turtleEvent;
  late StreamController<List<Message>> messageEventFirstTurtle;
  late StreamController<List<Message>> messageEventSecondTurtle;

  late bool setEmptyMessages;

  tearDown(() async {
    await turtleEvent.close();
    await messageEventFirstTurtle.close();
    await messageEventSecondTurtle.close();
    await iD.reset();
  });

  setUp(() {
    setEmptyMessages = false;
    turtleEvent = StreamController<BoxSocketState>();
    messageEventFirstTurtle = StreamController<List<Message>>();
    messageEventSecondTurtle = StreamController<List<Message>>();
    boxCom = MockBoxCommunication();
    boxConfig = MockBoxConfiguration();
    boxRepo = MockBoxRepository();
    messRepo = MockMessageRepository();
    deviceRepository = MockDeviceRepository();
    authRepository = MockAuthRepository();
    passwordGenerator = MockPasswordGenerator();
    iD.registerLazySingleton<BoxCommunication>(() => boxCom);
    iD.registerLazySingleton<AuthRepository>(() => authRepository);
    iD.registerLazySingleton<MessageRepository>(() => messRepo);

    iD.registerLazySingleton<BoxRepository>(() => boxRepo);
    iD.registerLazySingleton<DeviceRepository>(() => deviceRepository);
    iD.registerLazySingleton<BoxConfiguration>(() => boxConfig);
    iD.registerLazySingleton<PasswordGenerator>(() => passwordGenerator);

    iD.registerLazySingleton<BoxUseCase>(() => BoxUseCase(
          authRepository: iD(),
          deviceRepository: iD(),
          messageRepository: iD(),
          boxCommunication: iD(),
          boxConfig: iD(),
          boxRepository: iD(),
          passwordGenerator: iD(),
        ));

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

    when(deviceRepository.getDevice('1', DeviceType.turtle))
        .thenAnswer((_) async {
      return Turtle(
        id: '1',
        nameDevice: "test_turtle",
        fontSize: 20,
        showInfo: true,
        messageBeforeEnd: null,
        users: [],
      );
    });
    when(deviceRepository.getDevice('2', DeviceType.turtle))
        .thenAnswer((_) async {
      return Turtle(
        id: '2',
        nameDevice: "test_turtle2",
        fontSize: 20,
        showInfo: true,
        messageBeforeEnd: null,
        users: [],
      );
    });

    when(authRepository.signIn("test@test.com", "passwordtest"))
        .thenAnswer((_) async {
      return AuthDeviceUser(id: "1");
    });
    when(boxCom.listeningDeviceEvent()).thenAnswer((_) {
      return turtleEvent.stream;
    });
    when(messRepo.deviceMessages('1')).thenAnswer((_) {
      return messageEventFirstTurtle.stream;
    });
    when(messRepo.deviceMessages('2')).thenAnswer((_) {
      return messageEventSecondTurtle.stream;
    });

    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      if (!setEmptyMessages) {
        return [
          TextMessage(
              id: '200',
              fromId: '0',
              fromStr: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test text',
              needVocalAnswer: false,
              read: false),
        ];
      } else {
        return List.empty();
      }
    });
    when(messageUseCase.getNewMessages("2")).thenAnswer((realInvocation) async {
      if (!setEmptyMessages) {
        return [
          TextMessage(
              id: '300',
              fromId: '0',
              fromStr: 'test',
              to: '2',
              date: DateTime.now(),
              message: 'test text 2',
              needVocalAnswer: false,
              read: false),
        ];
      } else {
        return List.empty();
      }
    });
  });

  /**final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;**/

  testWidgets('test normal two turtles', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(makeTestableWidget(
      child: const BoxApp(),
      locale: const Locale('en'),
    ));
    await tester.pumpAndSettle();
    turtleEvent.add(DeviceConnected(id: '1', deviceType: DeviceType.turtle));
    turtleEvent.add(DeviceConnected(id: '2', deviceType: DeviceType.turtle));

    messageEventFirstTurtle.add(List.filled(
        1,
        TextMessage(
            id: '200',
            fromId: '0',
            fromStr: 'test',
            to: '1',
            date: DateTime.now(),
            message: 'test text toto',
            needVocalAnswer: false,
            read: false)));
    messageEventSecondTurtle.add(List.filled(
        1,
        TextMessage(
            id: '300',
            fromId: '0',
            fromStr: 'test',
            to: '2',
            date: DateTime.now(),
            message: 'test text tata',
            needVocalAnswer: false,
            read: false)));

    await tester.pumpAndSettle();
    verify(boxCom.newMessageReceived('1')).called(1);
    verify(boxCom.newMessageReceived('2')).called(1);

    await tester.pumpAndSettle();
    turtleEvent.add(const TurtleTapped(id: '2'));
    await tester.pumpAndSettle();
    expect(find.text('You received messages'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '2'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getNewMessages("2")).called(1);
    await tester.pumpAndSettle();
    setEmptyMessages = true;
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test text 2'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '2'));
    await tester.pumpAndSettle();
    verify(messRepo.setMessageRead("2", any)).called(1);
    verify(messageUseCase.getNewMessages("2")).called(1);
    await expectLater(find.byKey(const Key("goodByeText")), findsOneWidget);
    await tester.pump(const Duration(seconds: 12));
    await tester.pumpAndSettle();

    setEmptyMessages = false;
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    expect(find.text('You received messages'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getNewMessages("1")).called(1);
    await tester.pumpAndSettle();
    setEmptyMessages = true;
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test text'), findsOneWidget);

    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messRepo.setMessageRead("1", any)).called(1);
    verify(messageUseCase.getNewMessages("1")).called(1);
    await tester.pumpAndSettle();
    await expectLater(find.byKey(const Key("goodByeText")), findsOneWidget);
    await tester.pump(const Duration(seconds: 12));
    await tester.pump();
  });

  testWidgets('test normal two turtles and different tap',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(makeTestableWidget(
      child: const BoxApp(),
      locale: const Locale('en'),
    ));
    await tester.pumpAndSettle();
    turtleEvent.add(DeviceConnected(id: '1', deviceType: DeviceType.turtle));
    turtleEvent.add(DeviceConnected(id: '2', deviceType: DeviceType.turtle));

    messageEventFirstTurtle.add(List.filled(
        1,
        TextMessage(
            id: '400',
            fromId: '0',
            fromStr: 'test',
            to: '1',
            date: DateTime.now(),
            message: 'test text toto',
            needVocalAnswer: false,
            read: false)));
    messageEventSecondTurtle.add(List.filled(
        1,
        TextMessage(
            id: '500',
            fromId: '0',
            fromStr: 'test',
            to: '2',
            date: DateTime.now(),
            message: 'test text tata',
            needVocalAnswer: false,
            read: false)));

    await tester.pumpAndSettle();
    verify(boxCom.newMessageReceived('1')).called(1);
    verify(boxCom.newMessageReceived('2')).called(1);

    await tester.pumpAndSettle();
    turtleEvent.add(const TurtleTapped(id: '2'));
    await tester.pumpAndSettle();
    expect(find.text('You received messages'), findsOneWidget);
    //so turtle 1 tapped normally nothing happened
    turtleEvent.add(const TurtleTapped(id: '1'));
    verifyNever(messageUseCase.getNewMessages('1'));
    verifyNever(messageUseCase.getNewMessages('2'));
    await tester.pumpAndSettle();
    //so go to normal behavior
    turtleEvent.add(const TurtleTapped(id: '2'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getNewMessages("2")).called(1);
    await tester.pumpAndSettle();
    setEmptyMessages = true;
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test text 2'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '2'));
    await tester.pumpAndSettle();
    verify(messRepo.setMessageRead("2", any)).called(1);
    verify(messageUseCase.getNewMessages("2")).called(1);
    await expectLater(find.byKey(const Key("goodByeText")), findsOneWidget);
    await tester.pump(const Duration(seconds: 12));
    await tester.pumpAndSettle();

    setEmptyMessages = false;
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    expect(find.text('You received messages'), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getNewMessages("1")).called(1);
    await tester.pumpAndSettle();
    setEmptyMessages = true;
    await expectLater(find.text("test tells you :"), findsOneWidget);
    expect(find.text('test text'), findsOneWidget);

    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messRepo.setMessageRead("1", any)).called(1);
    verify(messageUseCase.getNewMessages("1")).called(1);
    await tester.pumpAndSettle();
    await expectLater(find.byKey(const Key("goodByeText")), findsOneWidget);
    await tester.pump(const Duration(seconds: 12));
    await tester.pump();
  });
}
