import 'package:flutter/material.dart';
import 'package:kisan_app/src/ui/views/authentication/login.dart';
import 'package:kisan_app/src/ui/views/authentication/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginScreen(toggleView);
    } else {
      return RegisterScreen(toggleView);
    }
  }
}
