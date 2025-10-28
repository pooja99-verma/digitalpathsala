// import 'package:digital_pathsala/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
//
//
// void main() {
//   runApp(const DigitalPathsalaApp());
// }
//
// class DigitalPathsalaApp extends StatelessWidget {
//   const DigitalPathsalaApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Digital Pathsala',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       debugShowCheckedModeBanner: false,
//       home: const SplashScreen(),
//     );
//   }
// }

import 'package:digital_pathsala/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const DigitalPathsalaApp());
}

class DigitalPathsalaApp extends StatelessWidget {
  const DigitalPathsalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pathsala',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
