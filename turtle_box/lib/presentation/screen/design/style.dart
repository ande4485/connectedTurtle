import 'package:flutter/material.dart';

ThemeData boxTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 25, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 25, color: Colors.white),
    ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen).copyWith(background: Colors.black));
