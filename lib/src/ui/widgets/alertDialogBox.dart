import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String message) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () => Navigator.pop(context, false),
  );
  Widget continueButton = FlatButton(
    child: Text("Yes"),
    onPressed: () => Navigator.pop(context, true),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Alert!",
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevation: 5.0,
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
