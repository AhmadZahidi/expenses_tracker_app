import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/screens/background_screen.dart';
import 'package:expenses_tracker_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: BackgroundScreen(greenBackground, LoginScreen()),
    ),
  );
}
