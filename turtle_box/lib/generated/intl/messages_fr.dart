// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(time) => "Plus de message, fin dans ${time} secondes";

  static String m1(deviceName) => "${deviceName} vous dit :";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accepted_phone":
            MessageLookupByLibrary.simpleMessage("Téléphone accepté"),
        "choose_what_you_want": MessageLookupByLibrary.simpleMessage(
            "Choisissez ce que vous voulez:"),
        "end_message": m0,
        "error_loading": MessageLookupByLibrary.simpleMessage(
            "Erreur, appuyez sur la tortue"),
        "exit": MessageLookupByLibrary.simpleMessage("Sortir"),
        "let_vocal_message":
            MessageLookupByLibrary.simpleMessage("Envoyer un message vocale à"),
        "no_message": MessageLookupByLibrary.simpleMessage("Pas de message"),
        "press_turtle":
            MessageLookupByLibrary.simpleMessage("Appuyez sur la tortue"),
        "press_turtle_select_choice": MessageLookupByLibrary.simpleMessage(
            "Appuyer sur la tortue pour :"),
        "press_turtle_select_user": MessageLookupByLibrary.simpleMessage(
            "Appuyer sur la tortue pour choisir un utilisateur :"),
        "press_turtle_when_finish": MessageLookupByLibrary.simpleMessage(
            "Appuyer sur la tortue quand vous avez fini de parler"),
        "press_turtle_when_ready": MessageLookupByLibrary.simpleMessage(
            "Appuyer sur la tortue quand vous êtes prêt à parler :"),
        "received_message":
            MessageLookupByLibrary.simpleMessage("Vous avez reçu un message"),
        "reminder": MessageLookupByLibrary.simpleMessage("Rappel"),
        "see_last_messages":
            MessageLookupByLibrary.simpleMessage("Voir les derniers messages"),
        "see_photos_videos_family": MessageLookupByLibrary.simpleMessage(
            "Voir les photos/videos de famille"),
        "send_message": MessageLookupByLibrary.simpleMessage(
            "Envoie du message, attendez s\'il vous plait"),
        "tells_you": m1,
        "wrong_password": MessageLookupByLibrary.simpleMessage(
            "Mauvais mot de passe, téléphone pas accepté"),
        "waiting_loading": MessageLookupByLibrary.simpleMessage("Attendez"),
      };
}
