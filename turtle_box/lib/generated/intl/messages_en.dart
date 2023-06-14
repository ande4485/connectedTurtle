// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(time) => "No more messages, end in ${time} seconds";

  static String m1(deviceName) => "${deviceName} tells you :";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accepted_phone":
            MessageLookupByLibrary.simpleMessage("Phone accepted"),
        "choose_what_you_want":
            MessageLookupByLibrary.simpleMessage("Choose what you want:"),
        "end_message": m0,
        "error_loading": MessageLookupByLibrary.simpleMessage(
            "ERROR, press ont turtle please"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "let_vocal_message":
            MessageLookupByLibrary.simpleMessage("Send vocal message to"),
        "no_message": MessageLookupByLibrary.simpleMessage("No messages"),
        "press_turtle": MessageLookupByLibrary.simpleMessage("Press on turtle"),
        "press_turtle_select_choice":
            MessageLookupByLibrary.simpleMessage("Press on turtle for :"),
        "press_turtle_select_user": MessageLookupByLibrary.simpleMessage(
            "Press on turtle to choose user :"),
        "press_turtle_when_finish": MessageLookupByLibrary.simpleMessage(
            "Press on turtle when you finish talking"),
        "press_turtle_when_ready": MessageLookupByLibrary.simpleMessage(
            "Press on turtle when you are ready to speak :"),
        "received_message":
            MessageLookupByLibrary.simpleMessage("You received messages"),
        "reminder": MessageLookupByLibrary.simpleMessage("reminder"),
        "see_last_messages":
            MessageLookupByLibrary.simpleMessage("See last messages"),
        "see_photos_videos_family": MessageLookupByLibrary.simpleMessage(
            "See photos/videos from family"),
        "send_message":
            MessageLookupByLibrary.simpleMessage("Send message, please wait"),
        "tells_you": m1,
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Wrong password, phone not accepted"),
        "waiting_loading": MessageLookupByLibrary.simpleMessage("Wait please"),
      };
}
