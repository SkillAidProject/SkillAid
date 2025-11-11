import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Bolder, Smart, and Eye-Catchy Color Palette (Consistent with Profile) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color borderGrey = Color(0xFFE0E0E0);
const Color redAccent = Color(0xFFE53935); // For reset/danger
const Color successGreen = Color(0xFF4CAF50); // For confirmation/test

// --- Notification Preference Data Model ---

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Global Toggles
  bool _masterSwitch = true;

  // Delivery Channels
  Map<String, bool> _channels = {
    'Push Notifications': true,
    'Email Alerts': false,
    'In-App Notifications': true,
  };

  // Notification Categories
  final Map<String, Map<String, String>> _categoriesData = {
    'Mentorship': {
      'Session Reminders': 'Alerts for upcoming or scheduled mentorship sessions.',
      'New Mentor Messages': 'Receive a ping when your mentor sends a new message.',
      'Booking Confirmations': 'Confirmation when a session is successfully booked or changed.',
      "Mentor's Q&A Response": 'Notification when a mentor answers your public question.',
    },
    'Courses and Skills': {
      'New Lesson Releases': 'Get notified when new content drops in your enrolled courses.',
      'Course Completion Alerts': 'Celebrate when you finish a course or milestone.',
    },
    'Achievements': {
      'Badges Earned': 'Alerts when you unlock a new skill badge or achievement.',
      'Certificates Unlocked': 'Notify when a new certificate is ready to download.',
    },
    'System & App': {
      'App Updates': 'Notifications about new features or stability fixes.',
      'Policy Changes': 'Important alerts regarding terms of service or privacy policy.',
      'Feature Announcements': 'Hear about new tools and sections of the app.',
    }
  };

  Map<String, bool> _categoryToggles = {}; // Will be initialized in initState

  // Quiet Hours / Do Not Disturb
  bool _quietHoursEnabled = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 22, minute: 0); // 10:00 PM
  TimeOfDay _endTime = const TimeOfDay(hour: 7, minute: 0); // 7:00 AM
  bool _muteDuringSession = true;

  @override
  void initState() {
    super.initState();
    _initializeToggles();
  }

  void _initializeToggles() {
    _categoryToggles = _categoriesData.entries.fold({}, (map, categoryEntry) {
      for (final item in categoryEntry.value.keys) {
        map[item] = true; // Default all category items to ON
      }
      return map;
    });
  }

  void _toggleMasterSwitch(bool value) {
    setState(() {
      _masterSwitch = value;
      // Toggle all channels and category items based on the master switch value
      for (final key in _channels.keys) {
        _channels[key] = value;
      }
      for (final key in _categoryToggles.keys) {
        _categoryToggles[key] = value;
      }
    });
  }

  void _resetToDefault() {
    setState(() {
      _masterSwitch = true;
      _initializeToggles(); // Reset category toggles
      _channels = {
        'Push Notifications': true,
        'Email Alerts': false,
        'In-App Notifications': true,
      };
      _quietHoursEnabled = false;
      _startTime = const TimeOfDay(hour: 22, minute: 0);
      _endTime = const TimeOfDay(hour: 7, minute: 0);
      _muteDuringSession = true;
      _showSnackBar('Preferences reset to default successfully.');
    });
  }

  void _showSnackBar(String message, {Color color = deepIndigo}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendTestNotification() {
    _showSnackBar('Sending test notification... (Check your Push/Email/In-App preview)', color: successGreen);
    // In a real app, this would trigger an actual API call.
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: deepIndigo,
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData icon = Icons.notifications_active_outlined,
    bool isMaster = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isMaster ? 4 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isMaster ? vibrantCyan : deepIndigo.withAlpha((0.7 * 255).toInt())),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isMaster ? FontWeight.bold : FontWeight.w600,
            fontSize: isMaster ? 16 : 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: darkGreyText.withAlpha((0.8 * 255).toInt())),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: vibrantCyan.withAlpha((0.5 * 255).toInt()),  // Track color when active
          activeThumbColor: vibrantCyan,                   // Thumb color when active
          inactiveThumbColor: borderGrey,
          inactiveTrackColor: lightBackground,
        ),
      ),
    );
  }

  Widget _buildCollapsibleCategory(String category, Map<String, String> items) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          '$category Notifications',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: deepIndigo,
            fontSize: 16,
          ),
        ),
        leading: Icon(_getCategoryIcon(category), color: deepIndigo),
        initiallyExpanded: false,
        collapsedIconColor: darkGreyText,
        iconColor: vibrantCyan,
        children: items.entries.map((item) {
          final title = item.key;
          final description = item.value;
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
            child: _buildToggleRow(
              title: title,
              subtitle: description,
              value: _categoryToggles[title] ?? true,
              onChanged: (value) {
                setState(() {
                  _categoryToggles[title] = value;
                });
              },
              icon: Icons.check_circle_outline,
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mentorship':
        return Icons.people_outline;
      case 'Courses and Skills':
        return Icons.school_outlined;
      case 'Achievements':
        return Icons.workspace_premium_outlined;
      case 'System & App':
        return Icons.settings_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text('Notification Preferences', style: TextStyle(color: Colors.black87)),
        backgroundColor: lightBackground,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // Extra space for floating buttons
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Global Toggles ---
            _buildSectionHeader('Global Control'),
            _buildToggleRow(
              title: 'Master Switch: Enable All Notifications',
              subtitle: 'Turn this off to instantly mute everything. Respecting your focus.',
              value: _masterSwitch,
              onChanged: _toggleMasterSwitch,
              icon: Icons.power_settings_new,
              isMaster: true,
            ),

            const SizedBox(height: 10),

            // --- Delivery Channels ---
            _buildSectionHeader('Delivery Channels'),
            ..._channels.entries.map((entry) {
              return _buildToggleRow(
                title: entry.key,
                subtitle: 'Receive alerts via ${entry.key.toLowerCase().replaceAll(' ', '')}.',
                value: entry.value,
                onChanged: _masterSwitch
                    ? (value) {
                        setState(() => _channels[entry.key] = value);
                      }
                    : (value) {}, // Disable if master switch is off
                icon: entry.key.contains('Push')
                    ? Icons.mobile_friendly
                    : entry.key.contains('Email')
                        ? Icons.email_outlined
                        : Icons.info_outline,
              );
            }),

            // --- 2. Notification Categories ---
            _buildSectionHeader('Notification Categories'),
            ..._categoriesData.entries.map((categoryEntry) {
              return _buildCollapsibleCategory(
                categoryEntry.key,
                categoryEntry.value,
              );
            }),

            // --- 3. Quiet Hours / Do Not Disturb ---
            _buildSectionHeader('Quiet Hours & Focus Mode'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildToggleRow(
                    title: 'Enable Quiet Hours',
                    subtitle: 'Mute all non-essential notifications during a set time range.',
                    value: _quietHoursEnabled,
                    onChanged: (value) {
                      setState(() => _quietHoursEnabled = value);
                    },
                    icon: Icons.nights_stay_outlined,
                  ),
                  if (_quietHoursEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: darkGreyText),
                          const SizedBox(width: 10),
                          const Text('From:', style: TextStyle(fontWeight: FontWeight.w500)),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: _startTime,
                              );
                              if (picked != null && picked != _startTime) {
                                setState(() => _startTime = picked);
                              }
                            },
                            child: Text(
                              _startTime.format(context),
                              style: const TextStyle(color: vibrantCyan, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          const Text('To:', style: TextStyle(fontWeight: FontWeight.w500)),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: _endTime,
                              );
                              if (picked != null && picked != _endTime) {
                                setState(() => _endTime = picked);
                              }
                            },
                            child: Text(
                              _endTime.format(context),
                              style: const TextStyle(color: vibrantCyan, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ListTile(
                    title: const Text('Mute During Active Sessions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Silence all alerts when you are in a mentorship or focus mode session.', style: TextStyle(fontSize: 12, color: darkGreyText)),
                    trailing: Switch.adaptive(
                      value: _muteDuringSession,
                      onChanged: (value) {
                        setState(() => _muteDuringSession = value);
                      },
                      activeTrackColor: vibrantCyan.withAlpha((0.5 * 255).toInt()),  // Track color when active
                      activeThumbColor: vibrantCyan, 
                      inactiveThumbColor: borderGrey,
                      inactiveTrackColor: lightBackground,
                    ),
                  ),
                ],
              ),
            ),

            // --- 4. Preview & Test ---
            _buildSectionHeader('Preview & Test'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                onPressed: _sendTestNotification,
                icon: const Icon(Icons.send_outlined, color: Colors.white),
                label: const Text('Send Test Notification', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notification Preview:', style: TextStyle(fontWeight: FontWeight.bold, color: deepIndigo)),
                    const SizedBox(height: 8),
                    // Mock Push Notification Preview
                    ListTile(
                      leading: const Icon(Icons.notifications_active, color: vibrantCyan),
                      title: const Text('Push: Session Reminder', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(_channels['Push Notifications']! ? 'You have a mentorship session with Jane Doe in 15 mins.' : 'Push disabled. (Will not show)', style: TextStyle(color: _channels['Push Notifications']! ? darkGreyText : redAccent)),
                      dense: true,
                    ),
                    // Mock Email Preview
                    ListTile(
                      leading: const Icon(Icons.email, color: deepIndigo),
                      title: const Text('Email: Course Completion', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(_channels['Email Alerts']! ? 'Congratulations! Your Python certificate is ready!' : 'Email disabled. (Will not show)', style: TextStyle(color: _channels['Email Alerts']! ? darkGreyText : redAccent)),
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // --- 5. Save and Reset Buttons (Floating Bottom Bar) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _resetToDefault,
                style: OutlinedButton.styleFrom(
                  foregroundColor: redAccent,
                  side: const BorderSide(color: redAccent, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Reset to Default', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Mock Save logic
                  _showSnackBar('Notification preferences saved!', color: vibrantCyan);
                  logger.i('Saved Preferences: Master=$_masterSwitch, Channels=$_channels');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: vibrantCyan,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                ),
                child: const Text('Save Preferences', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// App Wrapper for Single File Execution
// ----------------------------------------------------------------------------

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const SkillAidApp());
// }

// class SkillAidApp extends StatelessWidget {
//   const SkillAidApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SkillAid Settings',
//       theme: ThemeData(
//         useMaterial3: false,
//         primaryColor: deepIndigo,
//         scaffoldBackgroundColor: lightBackground,
//         fontFamily: 'Roboto',
//       ),
//       home: const NotificationSettingsScreen(),
//     );
//   }
// }