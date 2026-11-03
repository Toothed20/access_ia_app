import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const AccessIAApp());
}

class AccessIAApp extends StatelessWidget {
  const AccessIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AccessIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const HomeScreen(),
    );
  }
}
