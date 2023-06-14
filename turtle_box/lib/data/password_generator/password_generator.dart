import 'dart:math';

import 'package:turtle_box/domain/password_generator/password_generator.dart';

class PasswordGeneratorImpl extends PasswordGenerator {
  late String lastPassword;
  static const List passwordsPossible = [
    'a',
    'A',
    'b',
    'B',
    'C',
    'c',
    'D',
    'd',
    'E',
    'e',
    'f',
    'F',
    'G',
    'g',
    'H',
    'h',
    'I',
    'i',
    'J',
    'j',
    'K',
    'k',
    'L',
    'l',
    'J',
    'j',
    'K',
    'k',
    'L',
    'l',
    'M',
    'm',
    'N',
    'n',
    'O',
    'o',
    'P',
    'p'
        'Q',
    'q',
    'R',
    'r',
    'S',
    's',
    'T',
    't',
    'U',
    'u',
    'V',
    'v',
    'W',
    'w',
    'X',
    'x',
    'Y',
    'y',
    'Z',
    'z'
  ];

  @override
  String generatePassword() {
    var random = Random();
    String result = "";
    for (var i = 0; i < 4; i++) {
      var randomInt = random.nextInt(passwordsPossible.length);
      result += passwordsPossible[randomInt];
    }
    lastPassword = result;
    return result;
  }

  @override
  String getLastPassword() {
    return lastPassword;
  }
}
