import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:turtle_box/domain/communication/box_turtle_com.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/screen/design/constant.dart';
import 'package:turtle_package/data/communication/socket/box_socket_state.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/domain/usecase/box_message_usecase.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

import '../mock/generate_mock.mocks.dart';

checkStartBox(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await expectLater(find.byKey(const Key("ip_text")), findsOneWidget);
}

checkEndBox(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await expectLater(find.byKey(const Key("goodByeText")), findsOneWidget);
  await tester.pump(const Duration(seconds: TIME_BEFORE_END + 2));
}

checkStartNewMessages(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    StreamController<List<Message>> messageEvent,
    BoxCommunication boxCom) async {
  await checkStartBox(tester);
  turtleEvent.add(DeviceConnected(id: turtleId, deviceType: DeviceType.turtle));
  await tester.pump(const Duration(milliseconds: 300));
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
  await checkReceivedNewMessage(turtleId, tester, turtleEvent, boxCom);
}

checkMessageReadAndNewSearch(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    BoxMessageUseCase messageUseCase,
    MockMessageRepository messRepo,
    Message message) async {
  turtleEvent.add(TurtleTapped(id: turtleId));
  await tester.pump();
  verify(messRepo.setMessageRead(turtleId, message)).called(1);
  verify(messageUseCase.getNewMessages(turtleId)).called(1);
}

checkSearchNewMessages(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    BoxMessageUseCase messageUseCase) async {
  turtleEvent.add(TurtleTapped(id: turtleId));
  await tester.pump();
  verify(messageUseCase.getNewMessages(turtleId)).called(1);
}

checkReceivedNewMessage(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    BoxCommunication boxCom) async {
  turtleEvent.add(TurtleTapped(id: turtleId));
  await tester.pumpAndSettle();
  verify(boxCom.newMessageReceived(turtleId)).called(1);
  expect(find.text(S.current.received_message), findsOneWidget);
}

checkMessageText(
    String turtleId, WidgetTester tester, TextMessage textMessage) async {
  await tester.pumpAndSettle();
  await expectLater(
      find.text(S.current.tells_you(textMessage.fromStr)), findsOneWidget);
  expect(find.text(textMessage.message), findsOneWidget);
}

checkMessageImage(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    ImageMessage imageMessage) async {
  await tester.pumpAndSettle();
  await expectLater(
      find.text(S.current.tells_you(imageMessage.fromStr)), findsOneWidget);
  expect(find.text(imageMessage.message), findsOneWidget);
  for (var i = 0; i < imageMessage.link.length; i++) {
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    //TODO check image
  }
  //so we show image
}

checkMessageVideo(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    VideoMessage videoMessage) async {
  await tester.pumpAndSettle();
  await expectLater(
      find.text(S.current.tells_you(videoMessage.fromStr)), findsOneWidget);
  expect(find.text(videoMessage.message), findsOneWidget);
  for (var i = 0; i < videoMessage.link.length; i++) {
    turtleEvent.add(const TurtleTapped(id: '1'));
    await tester.pumpAndSettle();
    //TODO check image
  }
  //so we show image
}

checkMessageRead(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    MockMessageRepository messRepo,
    Message message) async {
  turtleEvent.add(TurtleTapped(id: turtleId));
  await tester.pumpAndSettle();
  verify(messRepo.setMessageRead(turtleId, message)).called(1);
}

checkVocalMessage(
    String turtleId,
    WidgetTester tester,
    StreamController<BoxSocketState> turtleEvent,
    SoundApi soundApi,
    UploadRepository uploadRepository,
    MockMessageRepository boxMessageRepository) async {
  when(soundApi.stopAudioRecord()).thenAnswer((_) async {
    return [];
  });
  when(uploadRepository.uploadSoundDatas([], turtleId)).thenAnswer((_) async {
    return "test";
  });
  expect(find.text(S.current.press_turtle_when_ready), findsOneWidget);
  verify(soundApi.initRecorder()).called(1);
  turtleEvent.add(TurtleTapped(id: turtleId));
  await tester.pumpAndSettle();
  expect(find.text(S.current.press_turtle_when_finish), findsOneWidget);
  verify(soundApi.recordAudio()).called(1);
  turtleEvent.add(TurtleTapped(id: turtleId));
  await tester.pumpAndSettle();
  verify(soundApi.stopAudioRecord()).called(1);
  verify(uploadRepository.uploadSoundDatas([], turtleId)).called(1);
  VocalMessage message =
      verify(boxMessageRepository.sendMessage(captureAny, '1')).captured.first;
  expect(message.type, MessageType.vocal.index);
  expect(message.link, "test");
  expect(message.fromId, turtleId);
  expect(message.fromStr, 'test_turtle');
  expect(message.to, '444');
}
