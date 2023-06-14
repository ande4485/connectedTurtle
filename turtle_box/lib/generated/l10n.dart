// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `See last messages`
  String get see_last_messages {
    return Intl.message(
      'See last messages',
      name: 'see_last_messages',
      desc: '',
      args: [],
    );
  }

  /// `See photos/videos from family`
  String get see_photos_videos_family {
    return Intl.message(
      'See photos/videos from family',
      name: 'see_photos_videos_family',
      desc: '',
      args: [],
    );
  }

  /// `Send vocal message to`
  String get let_vocal_message {
    return Intl.message(
      'Send vocal message to',
      name: 'let_vocal_message',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Press on turtle`
  String get press_turtle {
    return Intl.message(
      'Press on turtle',
      name: 'press_turtle',
      desc: '',
      args: [],
    );
  }

  /// `Press on turtle for :`
  String get press_turtle_select_choice {
    return Intl.message(
      'Press on turtle for :',
      name: 'press_turtle_select_choice',
      desc: '',
      args: [],
    );
  }

  /// `Press on turtle to choose user :`
  String get press_turtle_select_user {
    return Intl.message(
      'Press on turtle to choose user :',
      name: 'press_turtle_select_user',
      desc: '',
      args: [],
    );
  }

  /// `Press on turtle when you are ready to speak :`
  String get press_turtle_when_ready {
    return Intl.message(
      'Press on turtle when you are ready to speak :',
      name: 'press_turtle_when_ready',
      desc: '',
      args: [],
    );
  }

  /// `Press on turtle when you finish talking`
  String get press_turtle_when_finish {
    return Intl.message(
      'Press on turtle when you finish talking',
      name: 'press_turtle_when_finish',
      desc: '',
      args: [],
    );
  }

  /// `Send message, please wait`
  String get send_message {
    return Intl.message(
      'Send message, please wait',
      name: 'send_message',
      desc: '',
      args: [],
    );
  }

  /// `{deviceName} tells you :`
  String tells_you(Object deviceName) {
    return Intl.message(
      '$deviceName tells you :',
      name: 'tells_you',
      desc: '',
      args: [deviceName],
    );
  }

  /// `ERROR, press ont turtle please`
  String get error_loading {
    return Intl.message(
      'ERROR, press ont turtle please',
      name: 'error_loading',
      desc: '',
      args: [],
    );
  }

  /// `reminder`
  String get reminder {
    return Intl.message(
      'reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Choose what you want:`
  String get choose_what_you_want {
    return Intl.message(
      'Choose what you want:',
      name: 'choose_what_you_want',
      desc: '',
      args: [],
    );
  }

  /// `You received messages`
  String get received_message {
    return Intl.message(
      'You received messages',
      name: 'received_message',
      desc: '',
      args: [],
    );
  }

  /// `No more messages, end in {time} seconds`
  String end_message(Object time) {
    return Intl.message(
      'No more messages, end in $time seconds',
      name: 'end_message',
      desc: '',
      args: [time],
    );
  }

  /// `Wrong password, phone not accepted`
  String get wrong_password {
    return Intl.message(
      'Wrong password, phone not accepted',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Phone accepted`
  String get accepted_phone {
    return Intl.message(
      'Phone accepted',
      name: 'accepted_phone',
      desc: '',
      args: [],
    );
  }

  /// `No messages`
  String get no_message {
    return Intl.message(
      'No messages',
      name: 'no_message',
      desc: '',
      args: [],
    );
  }

  String get waiting_loading {
    return Intl.message(
      'Wait please',
      name: 'waiting_loading',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
