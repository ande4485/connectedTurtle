import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:turtle_box/domain/usecase/box_usecase.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/message/video_message_screen.dart';
import 'package:turtle_package/model/message.dart';

import '../../../mock/generate_mock.mocks.dart';
import '../../../utils/maketestable_widget.dart';
import '../../../utils/navigator_observer.dart';

void main() {
  late BoxUseCase boxUseCase;
  late StreamController<BoxState> turtleEvent;
  late MockNavigatorObserver mockObserver;

  setUpAll(() {
    turtleEvent = StreamController<BoxState>.broadcast();

    boxUseCase = MockBoxUseCase();
    mockObserver = MockNavigatorObserver();
    when(boxUseCase.getIp()).thenAnswer((_) async {
      return '127.0.0.1';
    });
    when(boxUseCase.boxEvent())
        .thenAnswer((realInvocation) => turtleEvent.stream);
  });

  tearDownAll(() {
    turtleEvent.close();
  });

  group('test video view screen', () {
    testWidgets('test video view with video widget.message',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      VideoMessage mess = VideoMessage(
          id: '400',
          fromId: "",
          fromStr: "toto",
          to: "",
          date: DateTime.now(),
          message: "test",
          link: ["https://youtu.be/FaDPFMTd9MM"],
          isFamily: false,
          needVocalAnswer: false,
          read: false);
      Widget widget = VideoMessagePage(message: mess, fontSize: 25);
      await tester.pumpWidget(makeTestableWidget(
          child: BlocProvider<BoxBloc>(
            create: (context) => BoxBloc(boxUseCase: boxUseCase),
            child: widget,
          ),
          locale: const Locale('en'),
          observer: mockObserver));

      await tester.pumpAndSettle();
      expect(find.text("toto tells you :"), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
      turtleEvent.add(BoxEventNext(time: DateTime.now()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text("toto tells you :"), findsNothing);
      expect(find.text('test'), findsNothing);
      turtleEvent.add(BoxEventNext(time: DateTime.now()));
      await tester.pump(const Duration(milliseconds: 500));
      when(mockObserver.didPop(
          MaterialPageRoute(builder: (context) => widget), any));
    });
  });
}
