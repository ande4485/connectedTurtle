import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/message/text_message_screen.dart';
import 'package:turtle_package/model/message.dart';

import '../../../mock/generate_mock.mocks.dart';
import '../../../utils/maketestable_widget.dart';
import '../../../utils/navigator_observer.dart';

void main() {
  final iD = GetIt.instance;

  late MockBoxUseCase boxUseCase;
  late StreamController<BoxState> turtleEvent;
  final mockObserver = MockNavigatorObserver();

  setUp(() {
    turtleEvent = StreamController<BoxState>.broadcast();
    boxUseCase = MockBoxUseCase();
  });

  tearDown(() async {
    turtleEvent.close();
    await iD.reset();
  });

  group('test text view screen', () {
    testWidgets('test text view with widget.message',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      TextMessage mess = TextMessage(
          id: '400',
          fromId: "",
          fromStr: "toto",
          to: "",
          date: DateTime.now(),
          message: "test",
          needVocalAnswer: false,
          read: false);
      when(boxUseCase.boxEvent())
          .thenAnswer((realInvocation) => turtleEvent.stream);
      Widget widget = TextMessagePage(message: mess, fontSize: 25);
      await tester.pumpWidget(makeTestableWidget(
          child: BlocProvider<BoxBloc>(
            create: (context) => BoxBloc(boxUseCase: boxUseCase),
            child: widget,
          ),
          locale: const Locale('en'),
          observer: mockObserver));

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text("toto tells you :"), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
      turtleEvent.add(BoxEventNext(time: DateTime.now()));
      when(mockObserver.didPop(
          MaterialPageRoute(builder: (context) => widget), any));
    });
  });
}
