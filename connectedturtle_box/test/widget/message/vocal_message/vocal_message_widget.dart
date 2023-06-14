import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import 'package:turtle_box/domain/usecase/sound_box_usecase.dart';
import 'package:turtle_box/generated/l10n.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/bloc/sound_box_bloc.dart';
import 'package:turtle_box/presentation/screen/vocal_recorder.dart';
import 'package:turtle_package/domain/repository/upload_repository.dart';

import 'package:turtle_package/domain/sound/sound_api.dart';
import 'package:turtle_package/model/device.dart';
import 'package:turtle_package/model/message.dart';

import '../../../mock/generate_mock.mocks.dart';
import '../../../utils/maketestable_widget.dart';
import '../../../utils/navigator_observer.dart';

void main() {
  final iD = GetIt.instance;
  late BoxBloc boxBloc;

  late SoundBoxBloc soundBoxBloc;
  late SoundApi soundApi;
  late UploadRepository uploadRepository;
  late MockMessageRepository boxMessageRepository;

  late SoundBoxUseCase soundBoxUseCase;
  late StreamController<BoxState> turtleEvent;
  final mockObserver = MockNavigatorObserver();

  setUpAll(() {
    turtleEvent = StreamController<BoxState>.broadcast();

    boxBloc = MockBoxBloc();
    boxMessageRepository = MockMessageRepository();
    soundApi = MockSoundApi();
    uploadRepository = MockUploadRepository();

    soundBoxUseCase = SoundBoxUseCase(
        soundApi: soundApi,
        uploadRepository: uploadRepository,
        boxMessageRepository: boxMessageRepository);
    soundBoxBloc = SoundBoxBloc(soundUseCase: soundBoxUseCase);
    iD.registerLazySingleton<BoxBloc>(() => boxBloc);
    iD.registerLazySingleton<SoundBoxBloc>(() => soundBoxBloc);
  });

  tearDownAll(() {
    turtleEvent.close();
  });

  group('test vocal recorder', () {
    testWidgets('test vocal recorder normal feature',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.

      Widget widget = VocalRecorderPage(
        currentDevice: Turtle(
          id: '1',
          nameDevice: "test_turtle",
          fontSize: 20,
          showInfo: true,
          messageBeforeEnd: null,
          users: [],
        ),
        toId: '350',
        answerForMessage: true,
      );
      await tester.pumpWidget(makeTestableWidget(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BoxBloc>(create: (_) => iD()),
              BlocProvider<SoundBoxBloc>(create: (_) => iD()),
            ],
            child: widget,
          ),
          locale: const Locale('en'),
          observer: mockObserver));
      when(soundApi.stopAudioRecord()).thenAnswer((_) async {
        return [];
      });
      when(uploadRepository.uploadSoundDatas([], '1')).thenAnswer((_) async {
        return "test";
      });
      when(boxBloc.stream).thenAnswer((realInvocation) => turtleEvent.stream);
      await tester.pump();

      expect(find.text(S.current.press_turtle_when_ready), findsOneWidget);
      verify(soundApi.initRecorder()).called(1);
      turtleEvent.add(BoxEventNext(time: DateTime.now()));
      await tester.pump();

      expect(find.text(S.current.press_turtle_when_finish), findsOneWidget);
      verify(soundApi.recordAudio()).called(1);
      turtleEvent.add(BoxEventNext(time: DateTime.now()));
      await tester.pumpAndSettle();

      //expect(find.text(S.current.send_message), findsOneWidget);
      verify(soundApi.stopAudioRecord()).called(1);
      verify(uploadRepository.uploadSoundDatas([], '1')).called(1);
      VocalMessage message =
          verify(boxMessageRepository.sendMessage(captureAny, '1'))
              .captured
              .first;
      expect(message.type, MessageType.vocal.index);
      expect(message.link, "test");
      expect(message.fromId, '1');
      expect(message.fromStr, 'test_turtle');
      expect(message.to, '350');
      when(mockObserver.didPop(
          MaterialPageRoute(builder: (context) => widget), any));
    });
  });
}
