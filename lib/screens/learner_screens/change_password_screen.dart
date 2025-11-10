import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions (Consistent with previous screens) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50); // For progress/success checks
const Color redAccent = Color(0xFFE53935); // For error messages
const Color borderGrey = Color(0xFFE0E0E0);
const Color disabledGrey = Color(0xFFB0BEC5);

// --- Main Change Password Screen Implementation ---

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Validation States for New Password Rules
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumberOrSymbol = false;
  
  // Overall Validation States
  bool _passwordsMatch = false;
  bool _isNewPasswordValid = false;

  // Feedback Message State
  String? _feedbackMessage;
  bool _isSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validateNewPassword);
    _confirmNewPasswordController.addListener(_validateConfirmation);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.removeListener(_validateNewPassword);
    _newPasswordController.dispose();
    _confirmNewPasswordController.removeListener(_validateConfirmation);
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _validateNewPassword() {
    final password = _newPasswordController.text;
    setState(() {
      // 1. Minimum 8 characters
      _hasMinLength = password.length >= 8;
      // 2. At least one uppercase letter (A-Z)
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      // 3. At least one number (0-9) or symbol (non-alphanumeric)
      _hasNumberOrSymbol = password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));

      _isNewPasswordValid = _hasMinLength && _hasUppercase && _hasNumberOrSymbol;

      // Also validate confirmation on new password change
      _validateConfirmation();
    });
  }

  void _validateConfirmation() {
    setState(() {
      _passwordsMatch = _newPasswordController.text == _confirmNewPasswordController.text && _confirmNewPasswordController.text.isNotEmpty;
    });
  }

  bool get _isFormValid {
    return _isNewPasswordValid && _passwordsMatch && _currentPasswordController.text.isNotEmpty;
  }

  void _showFeedback(String message, bool isSuccess) {
    setState(() {
      _feedbackMessage = message;
      _isSuccessMessage = isSuccess;
    });
    // Hide message after a few seconds
    Future.delayed(const Duration(seconds: 4), () {
      if(mounted) {
        setState(() {
          _feedbackMessage = null;
        });
      }
    });
  }

  void _handlePasswordChange() {
    // Mocking the password change logic:
    // 1. Check if current password is correct (mock: assume "123456" is the current password)
    if (_currentPasswordController.text != "CurrentMock123") {
      _showFeedback("Current password is incorrect. Please try again.", false);
      return;
    }

    // 2. Check if new passwords match (already handled by validation)
    if (!_passwordsMatch) {
      _showFeedback("New passwords do not match.", false);
      return;
    }

    // 3. Check if new password meets all rules (already handled by validation)
    if (!_isNewPasswordValid) {
      _showFeedback("New password does not meet all security guidelines.", false);
      return;
    }

    // Success (Mocking the action)
    logger.i("Password successfully changed for user.");
    _showFeedback("Your password has been updated successfully!", true);
    
    // Clear fields on success
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmNewPasswordController.clear();
  }

  Widget _buildPasswordRuleCheck(String rule, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle,
            size: 16,
            color: isMet ? successGreen : borderGrey,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              rule,
              style: TextStyle(
                fontSize: 14,
                color: isMet ? darkGreyText : darkGreyText.withAlpha((0.6 * 255).toInt()),
                fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        onChanged: (value) {
          if (label == 'Current Password') {
            setState(() {}); // Simply update state for button check
          } else if (label == 'New Password') {
            _validateNewPassword();
          } else {
            _validateConfirmation();
          }
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: deepIndigo.withAlpha((0.7 * 255).toInt())),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: borderGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: deepIndigo, width: 2),
          ),
          filled: true,
          fillColor: cardBackground,
          errorText: errorText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Mock navigation back
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Feedback Message ---
              if (_feedbackMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _isSuccessMessage ? successGreen.withAlpha((0.1 * 255).toInt()) : redAccent.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isSuccessMessage ? successGreen : redAccent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccessMessage ? Icons.check_circle_outline : Icons.error_outline,
                        color: _isSuccessMessage ? successGreen : redAccent,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          _feedbackMessage!,
                          style: TextStyle(
                            color: _isSuccessMessage ? successGreen : redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // --- Form Fields ---
              _buildTextField(
                controller: _currentPasswordController,
                label: 'Current Password',
                icon: Icons.lock_outline,
              ),

              _buildTextField(
                controller: _newPasswordController,
                label: 'New Password',
                icon: Icons.vpn_key_outlined,
              ),

              _buildTextField(
                controller: _confirmNewPasswordController,
                label: 'Confirm New Password',
                icon: Icons.check_circle_outline,
                errorText: _confirmNewPasswordController.text.isNotEmpty && !_passwordsMatch
                    ? 'Passwords do not match' : null,
              ),

              const SizedBox(height: 10),

              // --- Password Guidelines ---
              const Text(
                'Password Guidelines:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkGreyText,
                ),
              ),
              const SizedBox(height: 8),

              _buildPasswordRuleCheck(
                'Minimum 8 characters',
                _hasMinLength,
              ),
              _buildPasswordRuleCheck(
                'At least one uppercase letter (A-Z)',
                _hasUppercase,
              ),
              _buildPasswordRuleCheck(
                'At least one number or symbol',
                _hasNumberOrSymbol,
              ),

              const SizedBox(height: 30),

              // --- Action Buttons ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _handlePasswordChange : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? deepIndigo : disabledGrey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0, // Remove elevation for a modern look
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isFormValid ? Colors.white : Colors.white.withAlpha((0.7 * 255).toInt()),
                    ),
                  ),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// App Wrapper for Single File Execution
// ----------------------------------------------------------------------------

// void main() {
//   // To avoid runtime error in the buildActionTile mock functionality,
//   // we ensure Flutter bindings are initialized before calling runApp.
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const SkillAidPasswordApp());
// }

// class SkillAidPasswordApp extends StatelessWidget {
//   const SkillAidPasswordApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Change Password',
//       theme: ThemeData(
//         useMaterial3: false,
//         primaryColor: deepIndigo,
//         scaffoldBackgroundColor: lightBackground,
//         fontFamily: 'Roboto',
//         appBarTheme: const AppBarTheme(
//           backgroundColor: deepIndigo,
//           elevation: 0,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       // Use a simple Navigator to allow 'pop' functionality in the mock
//       home: Navigator(
//         onGenerateRoute: (settings) {
//           return MaterialPageRoute(
//             builder: (context) => const ChangePasswordScreen(),
//           );
//         },
//       ),
//     );
//   }
// }