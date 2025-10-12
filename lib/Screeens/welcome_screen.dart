import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool voiceNavigation = false;
  bool darkMode = false;
  String fontSize = 'M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // App logo
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'SA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "SkillAid",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B132B),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Learn Without Limits",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B132B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Color(0xFF0B132B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xFF0B132B)),
                  ),
                ),
                const SizedBox(height: 30),

                // Accessibility Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: darkMode ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Accessibility Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSwitchRow(
                        icon: Icons.volume_up,
                        title: "Screen Reader",
                        value: voiceNavigation,
                        onChanged: (val) {
                          setState(() => voiceNavigation = val);
                        },
                      ),
                      _buildSwitchRow(
                        icon: Icons.wb_sunny_outlined,
                        title: "Light/Dark Mode",
                        value: darkMode,
                        onChanged: (val) {
                          setState(() => darkMode = val);
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Font Size",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            ['S', 'M', 'L'].map((size) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(size),
                                  selected: fontSize == size,
                                  onSelected: (selected) {
                                    setState(() => fontSize = size);
                                  },
                                  selectedColor: const Color(0xFF0B132B),
                                  labelStyle: TextStyle(
                                    color:
                                        fontSize == size
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Powered by SkillAid",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0B132B)),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF0B132B),
        ),
      ],
    );
  }
}
