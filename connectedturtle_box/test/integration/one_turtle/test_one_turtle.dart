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
import '../../content_test/method_test.dart';
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

  late bool setEmptyMessages;

  tearDown(() async {
    await turtleEvent.close();
    await messageEvent.close();
    await iD.reset();
  });

  setUp(() {
    setEmptyMessages = false;
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

  /**  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;*/

  testWidgets('test normal one turtle one message',
      (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      if (!setEmptyMessages) {
        return [simpleTextMessage];
      } else {
        return List.empty();
      }
    });

    await tester.pumpWidget(makeTestableWidget(
      child: const BoxApp(),
      locale: const Locale('en'),
    ));
    await checkStartNewMessages(
        turtle1.id, tester, turtleEvent, messageEvent, boxCom);
    await checkSearchNewMessages(
        turtle1.id, tester, turtleEvent, messageUseCase);
    await checkMessageText(turtle1.id, tester, simpleTextMessage);
    setEmptyMessages = true;
    await checkSearchNewMessages(
        turtle1.id, tester, turtleEvent, messageUseCase);
    verify(messRepo.setMessageRead("1", simpleTextMessage)).called(1);
    await checkEndBox(tester);
    await checkStartBox(tester);
  });
  testWidgets('test normal one turtle all messages',
      (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      if (!setEmptyMessages) {
        return [
          simpleTextMessage,
          simpleImageMessage,
          simpleVideoMessage,
          /** YoutubeMessage(
              fromId: '0',
              fromString: 'test',
              to: '1',
              date: DateTime.now(),
              message: 'test youtube',
              needVocalAnswer: false,
              read: false, link: 'https://youtu.be/VReCpkav3RY'),**/
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

    await checkStartNewMessages(
        turtle1.id, tester, turtleEvent, messageEvent, boxCom);
    await checkSearchNewMessages(
        turtle1.id, tester, turtleEvent, messageUseCase);
    setEmptyMessages = true;
    await checkMessageText(turtle1.id, tester, simpleTextMessage);
    await checkMessageRead(
        turtle1.id, tester, turtleEvent, messRepo, simpleTextMessage);
    await checkMessageImage(
        turtle1.id, tester, turtleEvent, simpleImageMessage);
    await checkMessageRead(
        turtle1.id, tester, turtleEvent, messRepo, simpleImageMessage);
    await checkMessageVideo(
        turtle1.id, tester, turtleEvent, simpleVideoMessage);
    await checkMessageRead(
        turtle1.id, tester, turtleEvent, messRepo, simpleVideoMessage);
    verify(messageUseCase.getNewMessages("1")).called(1);
    await checkEndBox(tester);
    await checkStartBox(tester);
  });

  testWidgets('test one turtle with new messages during diapo',
      (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      if (!setEmptyMessages) {
        return [
          simpleTextMessage,
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

    await checkStartNewMessages(
        turtle1.id, tester, turtleEvent, messageEvent, boxCom);
    await checkSearchNewMessages(
        turtle1.id, tester, turtleEvent, messageUseCase);
    setEmptyMessages = true;
    await checkMessageText(turtle1.id, tester, simpleTextMessage);
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
    //turtle is in diapomode so doesn't have to blink
    verifyNever(boxCom.newMessageReceived(turtle1.id));
  });
}
