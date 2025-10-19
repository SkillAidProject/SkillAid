import 'package:flutter/material.dart';
import '../widgets/login_textfield.dart';

class LearnerAuthScreen extends StatefulWidget {
  const LearnerAuthScreen({super.key});

  @override
  State<LearnerAuthScreen> createState() => _LearnerAuthScreenState();
}

class _LearnerAuthScreenState extends State<LearnerAuthScreen> {
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

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
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Role tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🏆 Learner',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              isLogin ? 'Welcome Back' : 'Create Account',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              isLogin
                  ? 'Log in to continue learning'
                  : 'Join SkillAid today',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Toggle buttons
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
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
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
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Fields
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
            const SizedBox(height: 25),

            // ✅ Login / Sign Up Button with white text
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006BFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.white, // <-- makes text white
              ),
              onPressed: () {
                if (isLogin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Successful!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account Created!")),
                  );
                }
              },
              child: Text(
                isLogin ? 'Login' : 'Sign Up',
                style: const TextStyle(
                  color: Colors.white, // Ensure text color is white
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
