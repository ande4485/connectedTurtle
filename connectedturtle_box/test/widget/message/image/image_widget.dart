import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:turtle_box/presentation/bloc/box_bloc.dart';
import 'package:turtle_box/presentation/bloc/box_state.dart';
import 'package:turtle_box/presentation/screen/message/image_message_screen.dart';
import 'package:turtle_package/model/message.dart';

import '../../../utils/maketestable_widget.dart';
import '../../../utils/navigator_observer.dart';

import '../../../mock/generate_mock.mocks.dart';

void main() {
  late MockBoxUseCase boxUseCase;
  late StreamController<BoxState> turtleEvent;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    turtleEvent = StreamController<BoxState>.broadcast();
    boxUseCase = MockBoxUseCase();
    //_boxBloc =
    mockObserver = MockNavigatorObserver();
    //iD.registerLazySingleton<BoxBloc>(() => _boxBloc);
    when(boxUseCase.getIp()).thenAnswer((_) async {
      return '127.0.0.1';
    });
    when(boxUseCase.boxEvent())
        .thenAnswer((realInvocation) => turtleEvent.stream);
  });

  tearDown(() {
    turtleEvent.close();
  });

  testWidgets('test image view with one image', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    ImageMessage mess = ImageMessage(
        id: '100',
        fromId: "",
        fromStr: "toto",
        to: "",
        date: DateTime.now(),
        message: "test",
        link: [
          "https://fr.wikipedia.org/wiki/Tortue#/media/Fichier:Haeckel_Chelonia.jpg"
        ],
        isFamily: false,
        needVocalAnswer: false,
        read: false);

    Widget widget = ImageMessagePage(message: mess, fontSize: 25);
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
  testWidgets('test image view with multiple image',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    ImageMessage mess = ImageMessage(
        id: '400',
        fromId: "",
        fromStr: "toto",
        to: "",
        date: DateTime.now(),
        message: "test",
        link: [
          "https://fr.wikipedia.org/wiki/Tortue#/media/Fichier:Haeckel_Chelonia.jpg",
          "https://commons.wikimedia.org/wiki/File:Leatherback_sea_turtle_Tinglar,_USVI_(5839996547).jpg?uselang=fr",
          "https://commons.wikimedia.org/wiki/File:Testudo_hermanni_hermanni_Mallorca_02.jpg?uselang=fr"
        ],
        isFamily: false,
        needVocalAnswer: false,
        read: false);
    Widget widget = ImageMessagePage(message: mess, fontSize: 25);
    await tester.pumpWidget(makeTestableWidget(
        child: BlocProvider<BoxBloc>(
          create: (context) => BoxBloc(boxUseCase: boxUseCase),
          child: widget,
        ),
        locale: const Locale('en'),
        observer: mockObserver));

    //when(_boxBloc.stream).thenAnswer((realInvocation) => turtleEvent.stream);
    await tester.pumpAndSettle();
    expect(find.text("toto tells you :"), findsOneWidget);
    expect(find.text('test'), findsOneWidget);

    turtleEvent.add(BoxEventNext(time: DateTime.now()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("toto tells you :"), findsNothing);
    expect(find.text('test'), findsNothing);
    expect(find.byKey(const Key("ImageErrorText")), findsNothing);

    turtleEvent.add(BoxEventNext(time: DateTime.now()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("toto tells you :"), findsNothing);
    expect(find.text('test'), findsNothing);
    expect(find.byKey(const Key("ImageErrorText")), findsNothing);

    turtleEvent.add(BoxEventNext(time: DateTime.now()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("toto tells you :"), findsNothing);
    expect(find.text('test'), findsNothing);
    expect(find.byKey(const Key("ImageErrorText")), findsNothing);

    turtleEvent.add(BoxEventNext(time: DateTime.now()));
    await tester.pump(const Duration(milliseconds: 200));

    when(mockObserver.didPop(
        MaterialPageRoute(builder: (context) => widget), any));
  });
  testWidgets('test image view with error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    ImageMessage mess = ImageMessage(
        id: '444',
        fromId: "",
        fromStr: "toto",
        to: "",
        date: DateTime.now(),
        message: "test",
        link: [
          "https://",
        ],
        isFamily: false,
        needVocalAnswer: false,
        read: false);
    Widget widget = ImageMessagePage(message: mess, fontSize: 25);
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
    expect(find.byKey(const Key("ImageErrorText")), findsOneWidget);

    turtleEvent.add(BoxEventNext(time: DateTime.now()));
    await tester.pump(const Duration(milliseconds: 500));

    when(mockObserver.didPop(
        MaterialPageRoute(builder: (context) => widget), any));
  });
}
