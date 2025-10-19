import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'choose_role_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;
  final Function(double) onFontChange;
  final double fontScale;

  const WelcomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.onFontChange,
    required this.fontScale,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool voiceEnabled = false;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  Future<void> _speak(String text) async {
    if (voiceEnabled) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
    }
  }

  void _toggleVoice(bool value) async {
    setState(() {
      voiceEnabled = value;
    });
    if (value) {
      _speak("Voice navigation enabled");
    } else {
      await flutterTts.stop();
    }
  }

  void _onGetStarted() {
    _speak("Navigating to choose your role screen");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChooseRoleScreen()),
    );
  }

  void _onLoginPressed() {
    _speak("Navigating to choose your role screen");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChooseRoleScreen()),
    );
  }

  void _onFontSizeChange(double scale, String label) {
    widget.onFontChange(scale);
    _speak("$label font size selected");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFEAF6FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.grey[800] : Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/logo.png',
                  height: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'SkillAid',
                style: TextStyle(
                  fontSize: 28 * widget.fontScale,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Learn Without Limits',
                style: TextStyle(
                  fontSize: 14 * widget.fontScale,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Accessibility Card
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accessibility',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * widget.fontScale,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Voice Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.volume_up_outlined,
                                color: Colors.blue),
                            const SizedBox(width: 8),
                            Text('Voice Navigation',
                                style: TextStyle(
                                    fontSize: 14 * widget.fontScale,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black)),
                          ],
                        ),
                        Switch(
                          value: voiceEnabled,
                          onChanged: _toggleVoice,
                        ),
                      ],
                    ),

                    // Light Mode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                                isDark
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                                color: Colors.blue),
                            const SizedBox(width: 8),
                            Text('Light Mode',
                                style: TextStyle(
                                    fontSize: 14 * widget.fontScale,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black)),
                          ],
                        ),
                        Switch(
                          value: widget.isDarkMode,
                          onChanged: (value) {
                            widget.onThemeToggle(value);
                            _speak(value
                                ? "Light mode enabled"
                                : "Dark mode enabled");
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Font Size Options
                    Text('Font Size',
                        style: TextStyle(
                            fontSize: 14 * widget.fontScale,
                            color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _onFontSizeChange(0.8, "Small"),
                          child: Text(
                            'S',
                            style: TextStyle(
                              fontSize: 14 * widget.fontScale,
                              fontWeight: widget.fontScale == 0.8
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: widget.fontScale == 0.8
                                  ? Colors.blue
                                  : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _onFontSizeChange(1.0, "Medium"),
                          child: Text(
                            'M',
                            style: TextStyle(
                              fontSize: 14 * widget.fontScale,
                              fontWeight: widget.fontScale == 1.0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: widget.fontScale == 1.0
                                  ? Colors.blue
                                  : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _onFontSizeChange(1.3, "Large"),
                          child: Text(
                            'L',
                            style: TextStyle(
                              fontSize: 14 * widget.fontScale,
                              fontWeight: widget.fontScale == 1.3
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: widget.fontScale == 1.3
                                  ? Colors.blue
                                  : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Buttons
              ElevatedButton(
                onPressed: _onGetStarted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Get Started',
                    style: TextStyle(
                        fontSize: 16 * widget.fontScale,
                        color: Colors.white)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _onLoginPressed,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Login',
                    style: TextStyle(
                        fontSize: 16 * widget.fontScale, color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
