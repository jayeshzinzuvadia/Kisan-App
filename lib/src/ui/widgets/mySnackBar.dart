import 'package:flutter/material.dart';

SnackBar getSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        fontFamily: "Capriola",
      ),
    ),
  );
}
