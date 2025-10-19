import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const SkillAidApp());
}

class SkillAidApp extends StatefulWidget {
  const SkillAidApp({super.key});

  @override
  State<SkillAidApp> createState() => _SkillAidAppState();
}

class _SkillAidAppState extends State<SkillAidApp> {
  bool isDarkMode = false;
  double fontScale = 1.0; // 1.0 = Medium by default

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void setFontScale(double scale) {
    setState(() {
      fontScale = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillAid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor:
        isDarkMode ? Colors.grey[900] : const Color(0xFFEAF6FF),
        textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: fontScale),
        fontFamily: 'Poppins',
      ),
      home: WelcomeScreen(
        onThemeToggle: toggleTheme,
        isDarkMode: isDarkMode,
        onFontChange: setFontScale,
        fontScale: fontScale,
      ),
    );
  }
}
