import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:mockito/mockito.dart';
import 'package:turtle_box/domain/communication/box_turtle_com.dart';
import 'package:turtle_box/domain/config/box_config.dart';
import 'package:turtle_box/domain/password_generator/password_generator.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';
import 'package:turtle_box/domain/usecase/sound_box_usecase.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/main.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_message_bloc.dart';
import 'package:turtle_box/presentation/bloc/sound_box_bloc.dart';
import 'package:turtle_package/data/communication/socket/box_socket_state.dart';

import 'package:turtle_package/domain/repository/auth_repository.dart';

import 'package:turtle_package/domain/repository/box_repository.dart';
import 'package:turtle_package/domain/repository/device_repository.dart';
import 'package:turtle_package/domain/repository/message_repository.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/domain/usecase/box_message_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

import '../../content_test/method_test.dart';
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
  late SoundApi soundApi;
  late SoundBoxBloc soundBoxBloc;
  late SoundBoxUseCase soundBoxUseCase;
  late UploadRepository uploadRepository;
  late StreamController<List<Message>> messageEvent;
  int nbMessage = 1;

  tearDown(() async {
    turtleEvent.close();
    messageEvent.close();
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
    soundApi = MockSoundApi();
    uploadRepository = MockUploadRepository();

    soundBoxUseCase = SoundBoxUseCase(
        soundApi: soundApi,
        uploadRepository: uploadRepository,
        boxMessageRepository: messRepo);
    soundBoxBloc = SoundBoxBloc(soundUseCase: soundBoxUseCase);
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
    iD.registerLazySingleton<SoundBoxBloc>(() => soundBoxBloc);

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

  //IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test choice last message', (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      return [];
    });
    when(messageUseCase.getLastMessages("1"))
        .thenAnswer((realInvocation) async {
      if (nbMessage == 1) {
        return [simpleTextMessage];
      } else if (nbMessage == 0) {
        return [];
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
    await checkStartBox(tester);
    turtleEvent
        .add(DeviceConnected(id: turtle1.id, deviceType: DeviceType.turtle));
    await tester.pumpAndSettle();
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(seconds: 4));
    //normally choice appears
    await expectLater(find.text(S.current.see_last_messages), findsOneWidget);
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle();
    verify(messageUseCase.getLastMessages(turtle1.id)).called(1);
    await checkMessageText(turtle1.id, tester, simpleTextMessage);
    //so now we good end
    await checkSearchNewMessages(
        turtle1.id, tester, turtleEvent, messageUseCase);
    verifyNever(messRepo.setMessageRead(turtle1.id, simpleTextMessage));
    await checkEndBox(tester);
    await checkStartBox(tester);
  });

  testWidgets('test choice last message with empty last message',
      (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      return [];
    });
    when(messageUseCase.getLastMessages("1"))
        .thenAnswer((realInvocation) async {
      return [];
    });
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );

    await checkStartBox(tester);
    turtleEvent
        .add(DeviceConnected(id: turtle1.id, deviceType: DeviceType.turtle));
    await tester.pumpAndSettle();
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //normally choice appears
    await expectLater(find.text(S.current.see_last_messages), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getLastMessages('1')).called(1);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    //normally choice appears
    await expectLater(
        find.text(S.current.press_turtle_select_choice), findsOneWidget);
  });

  testWidgets('test choice family message', (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      return [];
    });
    when(messageUseCase.getFamilyMessages("1"))
        .thenAnswer((realInvocation) async {
      if (nbMessage == 1) {
        return [simpleImageMessage];
      } else if (nbMessage == 0) {
        return [];
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

    await checkStartBox(tester);
    turtleEvent
        .add(DeviceConnected(id: turtle1.id, deviceType: DeviceType.turtle));
    await tester.pumpAndSettle();
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(seconds: 6));
    //normally choice appears
    await expectLater(
        find.text(S.current.see_photos_videos_family), findsOneWidget);
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle();
    verify(messageUseCase.getFamilyMessages(turtle1.id)).called(1);
    await tester.pump();
    await checkMessageImage(
        turtle1.id, tester, turtleEvent, simpleImageMessage);
    await checkSearchNewMessages(
        turtle1.id, tester, turtleEvent, messageUseCase);
    verifyNever(messRepo.setMessageRead(turtle1.id, simpleImageMessage));
    await checkEndBox(tester);
    await checkStartBox(tester);
  });

  testWidgets('test choice family message with empty last message',
      (WidgetTester tester) async {
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      return [];
    });
    when(messageUseCase.getFamilyMessages("1"))
        .thenAnswer((realInvocation) async {
      return [];
    });
    when(messageUseCase.getLastMessages("1"))
        .thenAnswer((realInvocation) async {
      return [];
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
    await tester.pumpAndSettle();
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle(const Duration(seconds: 6));
    //normally choice appears
    await expectLater(
        find.text(S.current.see_photos_videos_family), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    verify(messageUseCase.getFamilyMessages('1')).called(1);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    //normally we come back
    await expectLater(
        find.text(S.current.press_turtle_select_choice), findsOneWidget);
  });

  testWidgets('test exit', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    when(messageUseCase.getNewMessages("1")).thenAnswer((realInvocation) async {
      return [];
    });
    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );

    await checkStartBox(tester);
    turtleEvent
        .add(DeviceConnected(id: turtle1.id, deviceType: DeviceType.turtle));
    await tester.pumpAndSettle();
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(seconds: 18));
    //normally choice appears
    await expectLater(find.text(S.current.exit), findsOneWidget);
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    //normally we go to end
    turtleEvent.add(const TurtleTapped(id: '1'));
    await checkEndBox(tester);
  });

  testWidgets('test vocal message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    when(messageUseCase.getNewMessages(turtle1.id))
        .thenAnswer((realInvocation) async {
      return [];
    });
    await tester.pumpWidget(
      makeTestableWidget(
        child: const BoxApp(),
        locale: const Locale('en'),
      ),
    );

    await checkStartBox(tester);
    turtleEvent
        .add(DeviceConnected(id: turtle1.id, deviceType: DeviceType.turtle));
    await tester.pumpAndSettle();
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(seconds: 12));
    //normally choice appears
    await expectLater(find.text(S.current.let_vocal_message), findsOneWidget);
    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    await expectLater(find.text(turtle1.users[0].name), findsOneWidget);

    turtleEvent.add(TurtleTapped(id: turtle1.id));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    //normally we go to vocal command
    await checkVocalMessage(
        turtle1.id, tester, turtleEvent, soundApi, uploadRepository, messRepo);
    await checkEndBox(tester);
  });
}
