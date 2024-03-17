import 'package:flutter/material.dart';
import 'package:healthmate/screens/splashscreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthMate', // Your app's title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define your app's theme
      ),
      home: const SplashScreen(), // Set the HomeScreen widget as the home screen
    );
  }
}
