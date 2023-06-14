import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'package:turtle_package/data/communication/socket/phone_box_socket_state.dart';

import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_phone/domain/config/wifi_information.dart';
import 'package:turtle_phone/domain/usecase/init_phone_usecase.dart';
import 'package:turtle_phone/presentation/bloc/init_device_bloc.dart';
import 'package:turtle_phone/presentation/screen/adddevices/add_devices.dart';

import '../mock/generate_mock.mocks.dart';
import '../utils/content_test.dart';
import '../utils/maketestable_widget.dart';

void main() {
  //IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late InitPhoneUseCase iniPhoneUseCase;
  late MockPhoneBoxCommunication phoneBoxCom;
  late MockPhoneDeviceCommunication phoneDeviceCommunication;
  late StreamController<PhoneBoxSocketState> boxEvent;
  late WifiInformation wifiInfo;
  late MockDeviceRepository deviceRepository;

  tearDown(() async {
    await boxEvent.close();
  });

  setUp(() async {
    boxEvent = StreamController<PhoneBoxSocketState>();
    deviceRepository = MockDeviceRepository();
    wifiInfo = MockWifiInformation();
    phoneBoxCom = MockPhoneBoxCommunication();
    phoneDeviceCommunication = MockPhoneDeviceCommunication();
    when(phoneBoxCom.listenBoxEvent()).thenAnswer((_) {
      return boxEvent.stream;
    });
    iniPhoneUseCase = InitPhoneUseCase(
        phoneBoxCommunication: phoneBoxCom,
        phoneDeviceCommunication: phoneDeviceCommunication,
        wifiInformation: wifiInfo,
        deviceRepository: deviceRepository);
  });

  testWidgets('test add turtle normal', (WidgetTester tester) async {
    when(phoneDeviceCommunication.testWifiDevice(any))
        .thenAnswer((realInvocation) async => true);

    when(phoneDeviceCommunication.findDevice(DeviceType.turtle))
        .thenAnswer((realInvocation) async => true);

    when(wifiInfo.getSSid())
        .thenAnswer((realInvocation) async => "TestWifiSSid");

    when(phoneBoxCom.connect("127.0.0.1"))
        .thenAnswer((realInvocation) async => "");

    when(phoneBoxCom.isConfig()).thenAnswer((realInvocation) async => true);
    when(phoneBoxCom.addTurtle(any)).thenAnswer((realInvocation) async => true);

    when(phoneDeviceCommunication.setConfig(any))
        .thenAnswer((realInvocation) async => true);
    when(deviceRepository.createDevice(any)).thenAnswer(
        (realInvocation) async => Turtle(
            id: '23',
            nameDevice: 'test',
            fontSize: 10,
            showInfo: false,
            users: []));

    await tester.pumpWidget(
      makeTestableWidget(
        child: BlocProvider<InitDeviceBloc>(
            create: (context) =>
                InitDeviceBloc(initPhoneUseCase: iniPhoneUseCase),
            child: const AddDevicesScreen(deviceType: DeviceType.turtle)),
        locale: const Locale('en'),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("field_ip")), "127.0.0.1");
    await tester.tap(find.byKey(const Key("bt_next")).at(0));
    boxEvent.add(BoxAskPassword());

    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key("field_password_box")), "aaaaa");
    await tester.tap(find.byKey(const Key("bt_next")).at(1));
    boxEvent.add(BoxAcceptSmartphone());
    await tester.pumpAndSettle();
    expect(find.text("TestWifiSSid"), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key("wifi_field_password")), "passwordWifi");
    await tester.tap(find.byKey(const Key("bt_next")).at(2));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key("name_turtle")), "turtle_name");
    await tester.enterText(
        find.byKey(const Key("name_owner_turtle")), "turtle_owner_name");
    await tester.enterText(find.byKey(const Key("last_name_owner_turtle")),
        "turtle_last_name_owner");
    var lastNextButton = find.byKey(const Key("bt_next")).at(3);
    await tester.dragUntilVisible(
      lastNextButton, // what you want to find
      find.byType(Stepper), // widget you want to scroll
      const Offset(300, 0), // delta to move
    );
    await tester.pumpAndSettle();
    await tester.tap(lastNextButton);
    await tester.pumpAndSettle();
    ConfigTurtle configTurtle =
        verify(phoneDeviceCommunication.setConfig(captureAny)).captured[0];

    expect(configTurtle.userId, admin.id);
    expect(configTurtle.ssid, "TestWifiSSid");
    expect(configTurtle.passwd, "passwordWifi");
    expect(configTurtle.ipBox, "127.0.0.1");
    expect(configTurtle.type, DeviceType.turtle);

    var values = verify(phoneBoxCom.addTurtle(captureAny)).captured;
    expect(values[0], "1");
    expect(values[1], "2");

    expect(find.byKey(const Key("icon_end")), findsOneWidget);
  });

  testWidgets('test add turtle and box config', (WidgetTester tester) async {
    when(phoneDeviceCommunication.testWifiDevice(any))
        .thenAnswer((realInvocation) async => true);

    when(phoneDeviceCommunication.findDevice(DeviceType.turtle))
        .thenAnswer((realInvocation) async => true);

    when(wifiInfo.getSSid())
        .thenAnswer((realInvocation) async => "TestWifiSSid");

    when(phoneBoxCom.connect("127.0.0.1"))
        .thenAnswer((realInvocation) async => "");

    when(phoneBoxCom.isConfig()).thenAnswer((realInvocation) async => false);
    when(phoneBoxCom.addTurtle(any)).thenAnswer((realInvocation) async => true);

    when(phoneDeviceCommunication.setConfig(any))
        .thenAnswer((realInvocation) async => true);
    when(deviceRepository.createDevice(any)).thenAnswer(
        (realInvocation) async => Turtle(
            id: '23',
            nameDevice: 'test',
            fontSize: 10,
            showInfo: false,
            users: []));

    await tester.pumpWidget(
      makeTestableWidget(
        child: BlocProvider<InitDeviceBloc>(
            create: (context) =>
                InitDeviceBloc(initPhoneUseCase: iniPhoneUseCase),
            child: const AddDevicesScreen(deviceType: DeviceType.turtle)),
        locale: const Locale('en'),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("field_ip")), "127.0.0.1");
    await tester.tap(find.byKey(const Key("bt_next")).at(0));
    boxEvent.add(BoxAskPassword());

    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key("field_password_box")), "aaaaa");
    await tester.tap(find.byKey(const Key("bt_next")).at(1));
    boxEvent.add(BoxAcceptSmartphone());
    await tester.pumpAndSettle();
    expect(find.text("TestWifiSSid"), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key("wifi_field_password")), "passwordWifi");
    await tester.tap(find.byKey(const Key("bt_next")).at(2));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key("name_turtle")), "turtle_name");
    await tester.enterText(
        find.byKey(const Key("name_owner_turtle")), "turtle_owner_name");
    await tester.enterText(find.byKey(const Key("last_name_owner_turtle")),
        "turtle_last_name_owner");
    var lastNextButton = find.byKey(const Key("bt_next")).at(3);
    await tester.dragUntilVisible(
      lastNextButton, // what you want to find
      find.byType(Stepper), // widget you want to scroll
      const Offset(300, 0), // delta to move
    );
    await tester.pumpAndSettle();
    await tester.tap(lastNextButton);
    await tester.pumpAndSettle();

    var values = verify(phoneBoxCom.addTurtle(captureAny)).captured;
    expect(values[0], "1");
    expect(values[1], "2");

    var valuesBox =
        verify(phoneBoxCom.setConfig(captureAny, captureAny)).captured;
    expect(valuesBox[0], "box@turtle");
    expect(valuesBox[1], "pswdBox");

    ConfigTurtle configTurtle =
        verify(phoneDeviceCommunication.setConfig(captureAny)).captured[0];

    expect(configTurtle.userId, admin.id);
    expect(configTurtle.ssid, "TestWifiSSid");
    expect(configTurtle.passwd, "passwordWifi");
    expect(configTurtle.ipBox, "127.0.0.1");
    expect(configTurtle.type, DeviceType.turtle);

    expect(find.byKey(const Key("icon_end")), findsOneWidget);
  });
}
