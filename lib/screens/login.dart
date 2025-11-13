import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:skillaid/screens/learner_screens/learner_dashboard_screen.dart';

final logger = Logger();

// --- Color Definitions (Refined for Minimalist Look) ---
const Color primaryBlue = Color(0xFF1E88E5); // A vibrant blue for actions
const Color lightGreyBackground = Color(0xFFF5F5F5); // Overall scaffold background
const Color darkGreyText = Color(0xFF5A5A5A); // Subtitle and body text
const Color borderGrey = Color(0xFFE0E0E0); // Light border color

// Social Media Brand Colors (Only used for icons and text)
const Color googleRed = Color(0xFFDB4437);
const Color appleBlack = Colors.black;
const Color facebookBlue = Color(0xFF1877F2);

// --- Main Login/Sign Up Screen ---

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  // State to toggle between Login (true) and Sign Up (false)
  bool _isLogin = true; 
  
  // Text editing controllers for the input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Mock function for email/password submission
  void _submitAuthForm() {
    if (_formKey.currentState!.validate()) {
      // API integration would happen here
      final email = _emailController.text;
      // final password = _passwordController.text;

      logger.i('Submitting Auth for: ${_isLogin ? 'SIGNIN' : 'SIGN UP'} with $email');
      
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const DashboardScreen()));
    }
  }

  // Mock function for social login
  void _socialLogin(String method) {
    logger.i('Attempting to log in with $method');
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting with $method...'),
          duration: const Duration(milliseconds: 1500),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- App Logo/Title ---
              const Image(
                image: ResizeImage(
                  AssetImage('assets/img/SkillAid2.png'),
                  width: 200,
                ),
              ),
              // const Text(
              //   'SkillAid',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 38,
              //     fontWeight: FontWeight.w900,
              //     color: primaryBlue,
              //     letterSpacing: -0.5,
              //   ),
              // ),
              const SizedBox(height: 0),
              Text(
                _isLogin ? 'Welcome Back!' : 'Start Your Learning Journey',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: darkGreyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // --- Toggle Switch (Login / Sign Up) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton('Sign In', true),
                  const SizedBox(width: 32),
                  _buildTabButton('Sign Up', false),
                ],
              ),
              const SizedBox(height: 20),

              // --- Auth Form ---
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    if(!_isLogin)
                    // Full Name Field
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      icon: Icons.person_outlined,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your full name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.alternate_email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outlined,
                      isObscure: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),

                    // Forgot Password (Only for Login)
                    _isLogin
                      ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              logger.i('Forgot Password tapped');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              logger.i('Apply to be a mentor tapped');
                            },
                            child: const Text(
                              'Apply to be a mentor',
                              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0, // Minimalist design
                      ),
                      child: Text(
                        _isLogin ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Divider for Social Login ---
              const Row(
                children: <Widget>[
                  Expanded(child: Divider(color: borderGrey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: darkGreyText, fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: borderGrey)),
                ],
              ),

              const SizedBox(height: 40),

              // --- Social Media Login Options (Clean Outlined Buttons) ---
              _buildSocialLoginButton(
                'Google',
                googleRed,
                Icons.mail, // Using public as a stand-in for Google
                () => _socialLogin('Google'),
              ),
              const SizedBox(height: 16),
              _buildSocialLoginButton(
                'Apple',
                appleBlack,
                Icons.apple,
                () => _socialLogin('Apple'),
              ),
              const SizedBox(height: 16),
              _buildSocialLoginButton(
                'Facebook',
                facebookBlue,
                Icons.facebook,
                () => _socialLogin('Facebook'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the sleek Login/Sign Up Tab button
  Widget _buildTabButton(String title, bool targetIsLogin) {
    final bool isSelected = _isLogin == targetIsLogin;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLogin = targetIsLogin;
          // Clear controllers when switching forms
          _formKey.currentState?.reset(); 
          _emailController.clear();
          _passwordController.clear();
          _fullNameController.clear();
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryBlue : darkGreyText.withAlpha((0.7 * 255).toInt()),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 3,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the custom text field (minimalist)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure,
      validator: validator,
      cursorColor: primaryBlue,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: darkGreyText, fontWeight: FontWeight.w400),
        prefixIcon: Icon(icon, color: primaryBlue, size: 20),
        
        // Minimalist Border Styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderGrey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderGrey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  // Helper widget for the social media login buttons (clean outline)
  Widget _buildSocialLoginButton(String text, Color color, IconData icon, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: borderGrey, width: 1.5), // Use light border color
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon, 
            color: color, // Social brand color for icon
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            'Continue with $text',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkGreyText, // Use dark text color for overall professionalism
            ),
          ),
        ],
      ),
    );
  }
}
