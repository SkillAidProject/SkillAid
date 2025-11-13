import 'package:flutter/material.dart';
import 'package:skillaid/screens/home.dart';
import 'package:skillaid/screens/learner_screens/learner_dashboard_screen.dart';
// import 'screens/welcome_screen.dart';

void main() {
  runApp(const SkillAidApp());
}

class SkillAidApp extends StatefulWidget {
  const SkillAidApp({super.key});

  @override
  State<SkillAidApp> createState() => _SkillAidAppState();
}

class _SkillAidAppState extends State<SkillAidApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillAid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false, 
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: lightGreyBackground,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
