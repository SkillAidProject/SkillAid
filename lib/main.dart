import 'package:flutter/material.dart';
import 'Screeens/welcome_screen.dart';
import 'Screeens/login_screen.dart';

void main() {
  runApp(const SkillAidApp());
}

class SkillAidApp extends StatelessWidget {
  const SkillAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillAid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0B132B),
      ),
      home:
          const WelcomeScreen(), // 👈 This tells Flutter to start from your custom screen
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
