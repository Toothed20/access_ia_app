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
        scaffoldBackgroundColor: const Color(0xFF131313), // background
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFFFFF), // primary text/icons
          onPrimary: Color(0xFF373100), // on-primary
          primaryContainer: Color(0xFFFEE400), // primary-container (Yellow)
          secondary: Color(0xFF00E3FD), // secondary-container (Cyan)
          surface: Color(0xFF201F1F), // surface-container
          onSurface: Color(0xFFE5E2E1), // on-surface
          error: Color(0xFFFF3838), // Destructive
        ),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}
