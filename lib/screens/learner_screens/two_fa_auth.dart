import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Bolder, Smart, and Eye-Catchy Color Palette (Consistent with Profile Screen) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // New, soft background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50); // For success messages
const Color errorRed = Color(0xFFE53935); // For errors/disabled states

// --- Main 2FA Screen Implementation ---

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

enum AuthMethod { authenticator, sms, email }
enum AuthStep { selection, verification, confirmation }

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  // State Management
  AuthStep _currentStep = AuthStep.selection;
  AuthMethod? _selectedMethod;
  String _verificationCode = '';
  
  // Timer for Resend Code
  int _resendSeconds = 30;
  Timer? _timer;

  // Confirmation Step States
  bool _isTwoFaEnabled = true; // Initial state after mock setup
  bool _trustDevice = false;

  @override
  void initState() {
    super.initState();
    // Start the timer only when step 2 is entered
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Step Control Logic ---

  void _startResendTimer() {
    _timer?.cancel();
    _resendSeconds = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  void _selectMethod(AuthMethod method) {
    if (method == AuthMethod.authenticator) return; // Feature not added yet
    setState(() {
      _selectedMethod = method;
      _currentStep = AuthStep.verification;
    });
    // Start timer immediately upon selecting the method
    _startResendTimer();
  }

  void _verifyCode(BuildContext context) {
    // Mock verification logic
    if (_verificationCode == '123456') { // Simple mock success
      setState(() {
        _currentStep = AuthStep.confirmation;
      });
      _timer?.cancel();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code. Please try again.')),
      );
    }
  }

  void _resendCode() {
    logger.i('Resending code via $_selectedMethod');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New code sent via ${_selectedMethod == AuthMethod.sms ? 'SMS' : 'Email'} (Mock)')),
    );
    _startResendTimer();
  }

  void _handleDisableToggle(BuildContext context, bool newValue) {
    if (!newValue) {
      // Show mock confirmation dialog for disabling 2FA
      _showPasswordConfirmationDialog(context);
    } else {
      // Re-enabling is immediate for mock
      setState(() {
        _isTwoFaEnabled = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('2FA has been re-enabled.')),
      );
    }
  }

  // --- UI Components ---

  Widget _buildAuthMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required AuthMethod method,
    required bool isComingSoon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedMethod == method;
    final bool isDisabled = isComingSoon;

    return GestureDetector(
      onTap: isDisabled ? () {} : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDisabled
              ? lightBackground
              : isSelected
                  ? deepIndigo.withAlpha((0.1 * 255).toInt())
                  : cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled
                ? errorRed.withAlpha((0.3 * 255).toInt())
                : isSelected
                    ? deepIndigo
                    : darkGreyText.withAlpha((0.2 * 255).toInt()),
            width: isDisabled ? 1 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: darkGreyText.withAlpha((0.05 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDisabled ? darkGreyText.withAlpha((0.5 * 255).toInt()) : deepIndigo,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? darkGreyText.withAlpha((0.5 * 255).toInt()) : Colors.black87,
                        ),
                      ),
                      if (isComingSoon)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: errorRed.withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Coming Soon',
                            style: TextStyle(color: errorRed, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDisabled ? darkGreyText.withAlpha((0.5 * 255).toInt()) : darkGreyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Selection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Choose Authentication Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        
        // Authenticator App (Coming Soon)
        _buildAuthMethodCard(
          icon: Icons.security,
          title: 'Authenticator App',
          subtitle: 'Use Google Authenticator, Authy, or similar apps for secure codes.',
          method: AuthMethod.authenticator,
          isComingSoon: true,
          onTap: () => _selectMethod(AuthMethod.authenticator),
        ),

        // SMS Verification
        _buildAuthMethodCard(
          icon: Icons.sms,
          title: 'SMS Verification',
          subtitle: 'Receive a six-digit code via text message to your phone number.',
          method: AuthMethod.sms,
          isComingSoon: false,
          onTap: () => _selectMethod(AuthMethod.sms),
        ),

        // Email Verification
        _buildAuthMethodCard(
          icon: Icons.email,
          title: 'Email Verification',
          subtitle: 'Receive a six-digit code in your primary email inbox.',
          method: AuthMethod.email,
          isComingSoon: false,
          onTap: () => _selectMethod(AuthMethod.email),
        ),
      ],
    );
  }

  Widget _buildStep2Verification(BuildContext context) {
    final String destination = _selectedMethod == AuthMethod.sms ? 'a masked number (** *** 1234)' : 'your email (u***@e***.com)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Step 2: Enter Verification Code',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: deepIndigo),
        ),
        const SizedBox(height: 16),
        Text(
          'Enter the 6-digit code sent to $destination to confirm setup.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: darkGreyText),
        ),
        const SizedBox(height: 30),
        
        // Code Input Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            onChanged: (value) {
              setState(() {
                _verificationCode = value;
              });
            },
            style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              hintText: '• • • • • •',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: darkGreyText, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: vibrantCyan, width: 2),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Resend Code Button with Timer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Didn\'t receive a code?',
              style: TextStyle(color: darkGreyText.withAlpha((0.7 * 255).toInt())),
            ),
            TextButton(
              onPressed: _resendSeconds == 0 ? _resendCode : null,
              child: Text(
                _resendSeconds == 0 ? 'Resend Code' : 'Resend in $_resendSeconds s',
                style: TextStyle(
                  color: _resendSeconds == 0 ? deepIndigo : darkGreyText.withAlpha((0.5 * 255).toInt()),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),
        
        // Verify Button
        _buildActionButton(
          text: 'Verify and Enable 2FA',
          onPressed: _verificationCode.length == 6 ? () => _verifyCode(context) : null,
          isPrimary: true,
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          text: 'Change Method',
          onPressed: () {
            _timer?.cancel();
            setState(() {
              _currentStep = AuthStep.selection;
              _selectedMethod = null;
            });
          },
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildStep3Confirmation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Icon(Icons.check_circle, color: successGreen, size: 80),
        ),
        const SizedBox(height: 16),
        const Text(
          '2FA is now enabled on your account!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: successGreen),
        ),
        const SizedBox(height: 8),
        Text(
          'Your account is protected using ${_selectedMethod == AuthMethod.sms ? 'SMS' : 'Email'} verification.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: darkGreyText),
        ),
        
        const Divider(height: 40),

        // Backup Codes Section
        const Text(
          'Recovery & Management',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        
        _buildActionButton(
          text: 'Download Backup Codes (Essential)',
          onPressed: () {
            logger.i('Downloading backup codes...');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mock: Backup Codes Downloaded! Keep them safe.')),
            );
          },
          icon: Icons.download,
          isPrimary: false,
        ),

        const SizedBox(height: 16),
        
        // Security Tip
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: vibrantCyan.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: vibrantCyan.withAlpha((0.5 * 255).toInt())),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: vibrantCyan),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'SECURITY TIP: Keep your backup codes safe and store them offline in a secure location.',
                  style: TextStyle(fontSize: 12, color: darkGreyText),
                ),
              ),
            ],
          ),
        ),
        
        const Divider(height: 40),

        // Disable 2FA Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Disable 2FA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: errorRed),
            ),
            Switch(
              value: _isTwoFaEnabled,
              onChanged: (newValue) => _handleDisableToggle(context, newValue),
              activeTrackColor: successGreen.withAlpha((0.3 * 255).toInt()),  // Track color when active
              activeThumbColor: successGreen, 
              inactiveTrackColor: errorRed.withAlpha((0.3 * 255).toInt()),
              inactiveThumbColor: errorRed,
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Device Trust Option
        Row(
          children: [
            Checkbox(
              value: _trustDevice,
              onChanged: (newValue) {
                setState(() {
                  _trustDevice = newValue ?? false;
                });
              },
              activeColor: deepIndigo,
            ),
            const Expanded(
              child: Text(
                'Don\'t ask again on this device for 30 days',
                style: TextStyle(fontSize: 14, color: darkGreyText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for consistent button styling
  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? deepIndigo : Colors.white,
          foregroundColor: isPrimary ? Colors.white : deepIndigo,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isPrimary ? BorderSide.none : const BorderSide(color: deepIndigo, width: 1.5),
          ),
          elevation: isPrimary ? 3 : 0,
        ),
        icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Custom Dialog for Password Confirmation (instead of alert())
  void _showPasswordConfirmationDialog(BuildContext context) {
    String password = '';
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirm Account Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('To disable 2FA, please enter your current password for security verification.'),
                const SizedBox(height: 15),
                TextField(
                  obscureText: true,
                  onChanged: (value) => password = value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: darkGreyText)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Reset the toggle if canceled
                setState(() => _isTwoFaEnabled = true); 
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: errorRed),
              child: const Text('Confirm Disable', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Mock password check
                if (password == 'validpassword') { 
                  setState(() {
                    _isTwoFaEnabled = false;
                    _currentStep = AuthStep.selection; // Back to step 1
                    _selectedMethod = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('2FA has been successfully disabled.')),
                  );
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid password. 2FA remains active.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // --- Overall Screen Layout ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text('2-Factor Authentication Setup', style: TextStyle(color: Colors.black87)),
        backgroundColor: lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentStep.index + 1) / AuthStep.values.length,
              backgroundColor: deepIndigo.withAlpha((0.2 * 255).toInt()),
              valueColor: const AlwaysStoppedAnimation<Color>(vibrantCyan),
            ),
            const SizedBox(height: 30),

            // Display current step content
            if (_currentStep == AuthStep.selection) _buildStep1Selection(),
            if (_currentStep == AuthStep.verification) _buildStep2Verification(context),
            if (_currentStep == AuthStep.confirmation) _buildStep3Confirmation(context),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. App Wrapper for Single File Execution
// -----------------------------------------------------------------------------

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const SkillAidAuthApp());
// }

// class SkillAidAuthApp extends StatelessWidget {
//   const SkillAidAuthApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '2FA Setup',
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
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: vibrantCyan),
//       ),
//       home: const TwoFactorAuthScreen(),
//     );
//   }
// }