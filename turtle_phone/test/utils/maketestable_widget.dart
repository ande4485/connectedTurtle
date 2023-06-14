import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:turtle_phone/generated/l10n.dart';

Widget makeTestableWidget(
    {required Widget child,
    required Locale locale,
    NavigatorObserver? observer}) {
  return MaterialApp(
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    locale: locale,
    home: child,
    navigatorObservers: observer != null ? [observer] : [],
  );
}
