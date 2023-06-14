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

  /// `settings`
  String get settings {
    return Intl.message(
      'settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `wrong font size`
  String get wrong_font_size {
    return Intl.message(
      'wrong font size',
      name: 'wrong_font_size',
      desc: '',
      args: [],
    );
  }

  /// `Message before end to switch channel`
  String get message_before_switch {
    return Intl.message(
      'Message before end to switch channel',
      name: 'message_before_switch',
      desc: '',
      args: [],
    );
  }

  /// `font size`
  String get font_size {
    return Intl.message(
      'font size',
      name: 'font_size',
      desc: '',
      args: [],
    );
  }

  /// `display information (like tap turtle)`
  String get display_information {
    return Intl.message(
      'display information (like tap turtle)',
      name: 'display_information',
      desc: '',
      args: [],
    );
  }

  /// `Problem to get turtle information`
  String get problem_to_get_turtle {
    return Intl.message(
      'Problem to get turtle information',
      name: 'problem_to_get_turtle',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users_management {
    return Intl.message(
      'Users',
      name: 'users_management',
      desc: '',
      args: [],
    );
  }

  /// `impossible to remove emergency users`
  String get impossible_to_remove_emergency_users {
    return Intl.message(
      'impossible to remove emergency users',
      name: 'impossible_to_remove_emergency_users',
      desc: '',
      args: [],
    );
  }

  /// `No emergency users`
  String get no_emergency_users {
    return Intl.message(
      'No emergency users',
      name: 'no_emergency_users',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to send`
  String get nothing_to_send {
    return Intl.message(
      'Nothing to send',
      name: 'nothing_to_send',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid youtube link`
  String get please_enter_valid_youtube {
    return Intl.message(
      'Please enter a valid youtube link',
      name: 'please_enter_valid_youtube',
      desc: '',
      args: [],
    );
  }

  /// `Url youtube`
  String get url_youtube {
    return Intl.message(
      'Url youtube',
      name: 'url_youtube',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with google`
  String get sign_google {
    return Intl.message(
      'Sign in with google',
      name: 'sign_google',
      desc: '',
      args: [],
    );
  }

  /// `Sign in fail`
  String get sign_failed {
    return Intl.message(
      'Sign in fail',
      name: 'sign_failed',
      desc: '',
      args: [],
    );
  }

  /// `error during selection`
  String get error_during_selection {
    return Intl.message(
      'error during selection',
      name: 'error_during_selection',
      desc: '',
      args: [],
    );
  }

  /// `you`
  String get you {
    return Intl.message(
      'you',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `your message`
  String get your_message {
    return Intl.message(
      'your message',
      name: 'your_message',
      desc: '',
      args: [],
    );
  }

  /// `Family moment`
  String get family_moment {
    return Intl.message(
      'Family moment',
      name: 'family_moment',
      desc: '',
      args: [],
    );
  }

  /// `Vocal answer`
  String get vocal_answer {
    return Intl.message(
      'Vocal answer',
      name: 'vocal_answer',
      desc: '',
      args: [],
    );
  }

  /// `Unknown user`
  String get unknown_user {
    return Intl.message(
      'Unknown user',
      name: 'unknown_user',
      desc: '',
      args: [],
    );
  }

  /// `User already exists`
  String get user_exist {
    return Intl.message(
      'User already exists',
      name: 'user_exist',
      desc: '',
      args: [],
    );
  }

  /// `Required a valid email address`
  String get email_address_not_valid {
    return Intl.message(
      'Required a valid email address',
      name: 'email_address_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to give admin right to {name} ? \n After you couldn't add users, change turtle settings etc ...`
  String admin_warning(Object name) {
    return Intl.message(
      'Are you sure to give admin right to $name ? \\n After you couldn\'t add users, change turtle settings etc ...',
      name: 'admin_warning',
      desc: '',
      args: [name],
    );
  }

  /// `No device`
  String get no_device {
    return Intl.message(
      'No device',
      name: 'no_device',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get add_device {
    return Intl.message(
      'Add Device',
      name: 'add_device',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is not available`
  String get no_bluetooth {
    return Intl.message(
      'Bluetooth is not available',
      name: 'no_bluetooth',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to quit ?`
  String get warning_quit {
    return Intl.message(
      'Are you sure to quit ?',
      name: 'warning_quit',
      desc: '',
      args: [],
    );
  }

  /// `Turtle not Found`
  String get turtle_not_found {
    return Intl.message(
      'Turtle not Found',
      name: 'turtle_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Enter IP box`
  String get enter_ip_box {
    return Intl.message(
      'Enter IP box',
      name: 'enter_ip_box',
      desc: '',
      args: [],
    );
  }

  /// `error connection box`
  String get error_connection_box {
    return Intl.message(
      'error connection box',
      name: 'error_connection_box',
      desc: '',
      args: [],
    );
  }

  /// `Wifi password`
  String get wifi_password {
    return Intl.message(
      'Wifi password',
      name: 'wifi_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter turtle name`
  String get enter_turtle_name {
    return Intl.message(
      'Enter turtle name',
      name: 'enter_turtle_name',
      desc: '',
      args: [],
    );
  }

  /// `Install finished`
  String get install_ok {
    return Intl.message(
      'Install finished',
      name: 'install_ok',
      desc: '',
      args: [],
    );
  }

  /// `Turtle users`
  String get turtle_users {
    return Intl.message(
      'Turtle users',
      name: 'turtle_users',
      desc: '',
      args: [],
    );
  }

  /// `Invited users`
  String get invited_users {
    return Intl.message(
      'Invited users',
      name: 'invited_users',
      desc: '',
      args: [],
    );
  }

  /// `Emergency users`
  String get emergency_users {
    return Intl.message(
      'Emergency users',
      name: 'emergency_users',
      desc: '',
      args: [],
    );
  }

  /// `added success`
  String get added_success {
    return Intl.message(
      'added success',
      name: 'added_success',
      desc: '',
      args: [],
    );
  }

  /// `added error`
  String get added_error {
    return Intl.message(
      'added error',
      name: 'added_error',
      desc: '',
      args: [],
    );
  }

  /// `remove user error`
  String get remove_user_error {
    return Intl.message(
      'remove user error',
      name: 'remove_user_error',
      desc: '',
      args: [],
    );
  }

  /// `add_emergency_user_error`
  String get add_emergency_user_error {
    return Intl.message(
      'add_emergency_user_error',
      name: 'add_emergency_user_error',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Add a person`
  String get add_person {
    return Intl.message(
      'Add a person',
      name: 'add_person',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_turtle {
    return Intl.message(
      'Delete',
      name: 'delete_turtle',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `Emergency`
  String get emergency {
    return Intl.message(
      'Emergency',
      name: 'emergency',
      desc: '',
      args: [],
    );
  }

  /// `• Verify you have Bluetooth on`
  String get verify_bluetooth {
    return Intl.message(
      '• Verify you have Bluetooth on',
      name: 'verify_bluetooth',
      desc: '',
      args: [],
    );
  }

  /// `• Don't switch off {device}`
  String dont_switch_off(Object device) {
    return Intl.message(
      '• Don\'t switch off $device',
      name: 'dont_switch_off',
      desc: '',
      args: [device],
    );
  }

  /// `• Don't switch off Android box`
  String get dont_switch_off_android_box {
    return Intl.message(
      '• Don\'t switch off Android box',
      name: 'dont_switch_off_android_box',
      desc: '',
      args: [],
    );
  }

  /// `• Verify app on android box is running`
  String get app_android_box_running {
    return Intl.message(
      '• Verify app on android box is running',
      name: 'app_android_box_running',
      desc: '',
      args: [],
    );
  }

  /// `• Verify you are in the same network (wifi) where you want to install {device}`
  String same_wifi(Object device) {
    return Intl.message(
      '• Verify you are in the same network (wifi) where you want to install $device',
      name: 'same_wifi',
      desc: '',
      args: [device],
    );
  }

  /// `{openCurly}"en": "English","fr": "French","it": "Italian"{closeCurly}`
  String languages_available(Object openCurly, Object closeCurly) {
    return Intl.message(
      '$openCurly"en": "English","fr": "French","it": "Italian"$closeCurly',
      name: 'languages_available',
      desc: '',
      args: [openCurly, closeCurly],
    );
  }

  /// `language`
  String get language {
    return Intl.message(
      'language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waiting_user {
    return Intl.message(
      'Waiting',
      name: 'waiting_user',
      desc: '',
      args: [],
    );
  }

  /// `Type email address ...`
  String get type_email_address {
    return Intl.message(
      'Type email address ...',
      name: 'type_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get title_warning {
    return Intl.message(
      'Warning',
      name: 'title_warning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to invit {emailAddress} ?`
  String warning_invit_user(Object emailAddress) {
    return Intl.message(
      'Are you sure to invit $emailAddress ?',
      name: 'warning_invit_user',
      desc: '',
      args: [emailAddress],
    );
  }

  /// `Information`
  String get user_information {
    return Intl.message(
      'Information',
      name: 'user_information',
      desc: '',
      args: [],
    );
  }

  /// `Youtube`
  String get youtube {
    return Intl.message(
      'Youtube',
      name: 'youtube',
      desc: '',
      args: [],
    );
  }

  /// `field required`
  String get required_field {
    return Intl.message(
      'field required',
      name: 'required_field',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get last_name {
    return Intl.message(
      'Last name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `User name for device (turtle, ...)`
  String get user_name_for_device {
    return Intl.message(
      'User name for device (turtle, ...)',
      name: 'user_name_for_device',
      desc: '',
      args: [],
    );
  }

  /// `Birthdate`
  String get birthdate {
    return Intl.message(
      'Birthdate',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `box`
  String get box {
    return Intl.message(
      'box',
      name: 'box',
      desc: '',
      args: [],
    );
  }

  /// `Wifi`
  String get wifi {
    return Intl.message(
      'Wifi',
      name: 'wifi',
      desc: '',
      args: [],
    );
  }

  /// `Emergency message`
  String get emergency_message {
    return Intl.message(
      'Emergency message',
      name: 'emergency_message',
      desc: '',
      args: [],
    );
  }

  /// `Turtle properties`
  String get turtle_properties {
    return Intl.message(
      'Turtle properties',
      name: 'turtle_properties',
      desc: '',
      args: [],
    );
  }

  /// `Error in wifi connection, check your password or wifi name`
  String get error_wifi_connection {
    return Intl.message(
      'Error in wifi connection, check your password or wifi name',
      name: 'error_wifi_connection',
      desc: '',
      args: [],
    );
  }

  /// `No connection with the box, verify IP`
  String get no_connection_box {
    return Intl.message(
      'No connection with the box, verify IP',
      name: 'no_connection_box',
      desc: '',
      args: [],
    );
  }

  /// `Problem to create turtle`
  String get pb_creation_turtle {
    return Intl.message(
      'Problem to create turtle',
      name: 'pb_creation_turtle',
      desc: '',
      args: [],
    );
  }

  /// `You are administrator of this turtle`
  String get finish_setup_admin {
    return Intl.message(
      'You are administrator of this turtle',
      name: 'finish_setup_admin',
      desc: '',
      args: [],
    );
  }

  /// `No {device} found.`
  String no_device_found(Object device) {
    return Intl.message(
      'No $device found.',
      name: 'no_device_found',
      desc: '',
      args: [device],
    );
  }

  /// `Please check {device} is on and your bluetooth on.`
  String please_check_device(Object device) {
    return Intl.message(
      'Please check $device is on and your bluetooth on.',
      name: 'please_check_device',
      desc: '',
      args: [device],
    );
  }

  /// `Box Password`
  String get box_pswd_smartphone {
    return Intl.message(
      'Box Password',
      name: 'box_pswd_smartphone',
      desc: '',
      args: [],
    );
  }

  /// `Password from TV`
  String get enter_password_on_tv {
    return Intl.message(
      'Password from TV',
      name: 'enter_password_on_tv',
      desc: '',
      args: [],
    );
  }

  /// `turtle owner name`
  String get enter_turtle_owner_name {
    return Intl.message(
      'turtle owner name',
      name: 'enter_turtle_owner_name',
      desc: '',
      args: [],
    );
  }

  /// `turtle owner last name`
  String get enter_turtle_owner_last_name {
    return Intl.message(
      'turtle owner last name',
      name: 'enter_turtle_owner_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Invited by :`
  String get invited_by {
    return Intl.message(
      'Invited by :',
      name: 'invited_by',
      desc: '',
      args: [],
    );
  }

  /// `Oops Error`
  String get oops_error {
    return Intl.message(
      'Oops Error',
      name: 'oops_error',
      desc: '',
      args: [],
    );
  }

  /// `Error with wifi, try later`
  String get error_wifi {
    return Intl.message(
      'Error with wifi, try later',
      name: 'error_wifi',
      desc: '',
      args: [],
    );
  }

  String get invit_accepted {
    return Intl.message(
      'Invitation accepted',
      name: 'invit_accepted',
      desc: '',
      args: [],
    );
  }

  String get error_during_invitation {
    return Intl.message(
      'Error during invitation',
      name: 'error_during_invitation',
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
