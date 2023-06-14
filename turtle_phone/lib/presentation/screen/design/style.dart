import 'package:flutter/material.dart';

import 'color.dart';

const spaceBetweenField = SizedBox(height: 15);
const TextFormDecoration = InputDecoration(
  //fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  ),
  //hintStyle: TextStyle(color: primary_color),
);

const TextStyleTitle = TextStyle(fontSize: 30.0);
