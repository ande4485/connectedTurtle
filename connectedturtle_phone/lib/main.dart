import 'package:flutter/material.dart';
import 'package:turtle_phone/di/phone_di.dart' as phone_di;
import 'package:turtle_phone/phone_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await phone_di.init();
  runApp(PhoneApp());
}
