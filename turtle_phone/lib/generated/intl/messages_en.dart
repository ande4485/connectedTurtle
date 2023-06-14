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

  static String m0(name) =>
      "Are you sure to give admin right to ${name} ? \\n After you couldn\'t add users, change turtle settings etc ...";

  static String m1(device) => "• Don\'t switch off ${device}";

  static String m2(openCurly, closeCurly) =>
      "${openCurly}\"en\": \"English\",\"fr\": \"French\",\"it\": \"Italian\"${closeCurly}";

  static String m3(device) => "No ${device} found.";

  static String m4(device) =>
      "Please check ${device} is on and your bluetooth on.";

  static String m5(device) =>
      "• Verify you are in the same network (wifi) where you want to install ${device}";

  static String m6(emailAddress) => "Are you sure to invit ${emailAddress} ?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_device": MessageLookupByLibrary.simpleMessage("Add Device"),
        "add_emergency_user_error":
            MessageLookupByLibrary.simpleMessage("add_emergency_user_error"),
        "add_person": MessageLookupByLibrary.simpleMessage("Add a person"),
        "added_error": MessageLookupByLibrary.simpleMessage("added error"),
        "added_success": MessageLookupByLibrary.simpleMessage("added success"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "admin_warning": m0,
        "app_android_box_running": MessageLookupByLibrary.simpleMessage(
            "• Verify app on android box is running"),
        "birthdate": MessageLookupByLibrary.simpleMessage("Birthdate"),
        "box": MessageLookupByLibrary.simpleMessage("box"),
        "box_pswd_smartphone":
            MessageLookupByLibrary.simpleMessage("Box Password"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "delete_turtle": MessageLookupByLibrary.simpleMessage("Delete"),
        "display_information": MessageLookupByLibrary.simpleMessage(
            "display information (like tap turtle)"),
        "dont_switch_off": m1,
        "dont_switch_off_android_box": MessageLookupByLibrary.simpleMessage(
            "• Don\'t switch off Android box"),
        "email_address_not_valid": MessageLookupByLibrary.simpleMessage(
            "Required a valid email address"),
        "emergency": MessageLookupByLibrary.simpleMessage("Emergency"),
        "emergency_message":
            MessageLookupByLibrary.simpleMessage("Emergency message"),
        "emergency_users":
            MessageLookupByLibrary.simpleMessage("Emergency users"),
        "enter_ip_box": MessageLookupByLibrary.simpleMessage("Enter IP box"),
        "enter_password_on_tv":
            MessageLookupByLibrary.simpleMessage("Password from TV"),
        "enter_turtle_name":
            MessageLookupByLibrary.simpleMessage("Enter turtle name"),
        "enter_turtle_owner_last_name":
            MessageLookupByLibrary.simpleMessage("turtle owner last name"),
        "enter_turtle_owner_name":
            MessageLookupByLibrary.simpleMessage("turtle owner name"),
        "error_connection_box":
            MessageLookupByLibrary.simpleMessage("error connection box"),
        "error_during_selection":
            MessageLookupByLibrary.simpleMessage("error during selection"),
        "error_wifi":
            MessageLookupByLibrary.simpleMessage("Error with wifi, try later"),
        "error_wifi_connection": MessageLookupByLibrary.simpleMessage(
            "Error in wifi connection, check your password or wifi name"),
        "family_moment": MessageLookupByLibrary.simpleMessage("Family moment"),
        "finish_setup_admin": MessageLookupByLibrary.simpleMessage(
            "You are administrator of this turtle"),
        "font_size": MessageLookupByLibrary.simpleMessage("font size"),
        "image": MessageLookupByLibrary.simpleMessage("Image"),
        "impossible_to_remove_emergency_users":
            MessageLookupByLibrary.simpleMessage(
                "impossible to remove emergency users"),
        "install_ok": MessageLookupByLibrary.simpleMessage("Install finished"),
        "invited_by": MessageLookupByLibrary.simpleMessage("Invited by :"),
        "invited_users": MessageLookupByLibrary.simpleMessage("Invited users"),
        "language": MessageLookupByLibrary.simpleMessage("language"),
        "languages_available": m2,
        "last_name": MessageLookupByLibrary.simpleMessage("Last name"),
        "message_before_switch": MessageLookupByLibrary.simpleMessage(
            "Message before end to switch channel"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "no_bluetooth":
            MessageLookupByLibrary.simpleMessage("Bluetooth is not available"),
        "no_connection_box": MessageLookupByLibrary.simpleMessage(
            "No connection with the box, verify IP"),
        "no_device": MessageLookupByLibrary.simpleMessage("No device"),
        "no_device_found": m3,
        "no_emergency_users":
            MessageLookupByLibrary.simpleMessage("No emergency users"),
        "nothing_to_send":
            MessageLookupByLibrary.simpleMessage("Nothing to send"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "oops_error": MessageLookupByLibrary.simpleMessage("Oops Error"),
        "pb_creation_turtle":
            MessageLookupByLibrary.simpleMessage("Problem to create turtle"),
        "please_check_device": m4,
        "please_enter_valid_youtube": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid youtube link"),
        "problem_to_get_turtle": MessageLookupByLibrary.simpleMessage(
            "Problem to get turtle information"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "remove_user_error":
            MessageLookupByLibrary.simpleMessage("remove user error"),
        "required_field":
            MessageLookupByLibrary.simpleMessage("field required"),
        "same_wifi": m5,
        "save": MessageLookupByLibrary.simpleMessage("save"),
        "settings": MessageLookupByLibrary.simpleMessage("settings"),
        "sign_failed": MessageLookupByLibrary.simpleMessage("Sign in fail"),
        "sign_google":
            MessageLookupByLibrary.simpleMessage("Sign in with google"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "title_warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "turtle_not_found":
            MessageLookupByLibrary.simpleMessage("Turtle not Found"),
        "turtle_properties":
            MessageLookupByLibrary.simpleMessage("Turtle properties"),
        "turtle_users": MessageLookupByLibrary.simpleMessage("Turtle users"),
        "type_email_address":
            MessageLookupByLibrary.simpleMessage("Type email address ..."),
        "unknown_user": MessageLookupByLibrary.simpleMessage("Unknown user"),
        "url_youtube": MessageLookupByLibrary.simpleMessage("Url youtube"),
        "user_exist":
            MessageLookupByLibrary.simpleMessage("User already exists"),
        "user_information": MessageLookupByLibrary.simpleMessage("Information"),
        "user_name_for_device": MessageLookupByLibrary.simpleMessage(
            "User name for device (turtle, ...)"),
        "users_management": MessageLookupByLibrary.simpleMessage("Users"),
        "verify_bluetooth": MessageLookupByLibrary.simpleMessage(
            "• Verify you have Bluetooth on"),
        "video": MessageLookupByLibrary.simpleMessage("Video"),
        "vocal_answer": MessageLookupByLibrary.simpleMessage("Vocal answer"),
        "waiting_user": MessageLookupByLibrary.simpleMessage("Waiting"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "warning_invit_user": m6,
        "warning_quit":
            MessageLookupByLibrary.simpleMessage("Are you sure to quit ?"),
        "wifi": MessageLookupByLibrary.simpleMessage("Wifi"),
        "wifi_password": MessageLookupByLibrary.simpleMessage("Wifi password"),
        "wrong_font_size":
            MessageLookupByLibrary.simpleMessage("wrong font size"),
        "you": MessageLookupByLibrary.simpleMessage("you"),
        "your_message": MessageLookupByLibrary.simpleMessage("your message"),
        "youtube": MessageLookupByLibrary.simpleMessage("Youtube"),
        "invit_accepted":
            MessageLookupByLibrary.simpleMessage("Invitation accepted"),
        "error_during_invitation":
            MessageLookupByLibrary.simpleMessage("Error during invitation")
      };
}
