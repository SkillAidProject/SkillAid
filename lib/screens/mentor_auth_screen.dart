import 'package:flutter/material.dart';
import '../widgets/login_textfield.dart';

class MentorAuthScreen extends StatefulWidget {
  const MentorAuthScreen({super.key});

  @override
  State<MentorAuthScreen> createState() => _MentorAuthScreenState();
}

class _MentorAuthScreenState extends State<MentorAuthScreen> {
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _expertise1Controller = TextEditingController();
  final _expertise2Controller = TextEditingController();
  final _expertise3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : const Color(0xFFEAF6FF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // 🏅 Role Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🏅 Mentor',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              isLogin ? 'Welcome Back' : 'Create Account',
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              isLogin ? 'Log in to continue learning' : 'Join SkillAid today',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // 🔄 Toggle Buttons
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isLogin = true),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isLogin ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isLogin = false),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isLogin ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 👤 Fields
            if (!isLogin) ...[
              Row(
                children: [
                  Expanded(
                    child: LoginTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      hint: 'John',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LoginTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      hint: 'Doe',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],

            LoginTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'your@email.com',
            ),
            const SizedBox(height: 15),

            LoginTextField(
              controller: _passwordController,
              label: 'Password',
              hint: '••••••••',
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // 🧠 Mentor sign-up extras
            if (!isLogin) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Areas of Expertise (up to 3)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Always-visible subtle grey hints
              _expertiseTextField(_expertise1Controller, 'e.g., Web Development'),
              const SizedBox(height: 10),
              _expertiseTextField(_expertise2Controller, 'e.g., Data Science'),
              const SizedBox(height: 10),
              _expertiseTextField(_expertise3Controller, 'e.g., UI/UX Design'),
              const SizedBox(height: 15),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your account will be activated after admin approval',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 🚀 Login / Sign Up Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006BFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isLogin
                        ? "Mentor Login Successful!"
                        : "Mentor Account Created!"),
                  ),
                );
              },
              child: Text(
                isLogin ? 'Login' : 'Sign Up',
                style: const TextStyle(
                  color: Colors.white, // visible white text
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ✅ Custom local text field for expertise (always show hint, soft grey)
  Widget _expertiseTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[500], // 👈 subtle grey hint text
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(color: Color(0xFF006BFF), width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
