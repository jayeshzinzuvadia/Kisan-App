import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';

Future<void> main() async {
  // Below steps are required for initializing firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
