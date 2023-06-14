import 'package:flutter/material.dart';
import 'package:turtle_box/main.dart';
import 'package:turtle_box/di/box_di.dart' as dibox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dibox.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BoxApp();
  }
}
