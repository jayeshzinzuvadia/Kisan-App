import 'dart:ui';

import 'package:flutter/material.dart';
import '../../app.dart';

Widget mainAppBar(BuildContext context) {
  return AppBar(
    title: Text(UniversalConstant.APP_NAME),
    backgroundColor: Colors.lightGreen[800],
    centerTitle: true,
  );
}

// For AppBar
Widget myAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: Colors.lightGreen[800],
    centerTitle: true,
  );
}

// For text input field
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.greenAccent,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.green,
      width: 2.0,
    ),
  ),
);

// For Text Field Decoration
InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(),
    focusedBorder: UnderlineInputBorder(),
    enabledBorder: UnderlineInputBorder(),
  );
}

// For text style
TextStyle simpleTextStyle() {
  return TextStyle(
    // color: Colors.white,
    fontSize: 14.0,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    fontSize: 16.0,
  );
}

TextStyle mediumTextStyleWhiteColor() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );
}

TextStyle validationMessageTextStyle() {
  return TextStyle(
    color: Colors.red,
    fontSize: 14.0,
  );
}
