import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:skillaid/screens/learner_screens/certificate_screen.dart';
import 'package:skillaid/screens/learner_screens/bookings_screen.dart';
import 'package:skillaid/screens/learner_screens/questions_screen.dart';
import 'package:skillaid/screens/learner_screens/filemanager_screen.dart';
import 'package:skillaid/screens/learner_screens/change_password_screen.dart';
import 'package:skillaid/screens/learner_screens/2fa_auth.dart';
import 'notifications_screen.dart';

final logger = Logger();

// --- Bolder, Smart, and Eye-Catchy Color Palette ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // New, soft background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50); // For progress
const Color streakOrange = Color(0xFFFF9800); // For streaks/highlights
const Color borderGrey = Color(0xFFE0E0E0);
const Color redAccent = Color(0xFFE53935);

// --- Data Models (Unchanged) ---
class Program {
  final String title;
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  Program({required this.title, required this.progress, this.isCompleted = false});
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  Achievement({required this.title, required this.description, required this.icon, required this.color});
}

class Recommendation {
  final String title;
  final String type; // e.g., 'Skill', 'Course', 'Program'
  final Color color;
  Recommendation({required this.title, required this.type, required this.color});
}

class Learner {
  final String name;
  final String title;
  final String imageUrl;
  final String location;
  final String preferredLanguage;
  String learningGoal; // Made mutable for editing
  final double overallProgress; 
  // final List<Program> currentPrograms;
  final List<Program> completedPrograms;
  final List<Achievement> achievements;
  final int streakDays;

  Learner({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.preferredLanguage,
    required this.learningGoal,
    required this.overallProgress,
    // required this.currentPrograms,
    required this.completedPrograms,
    required this.achievements,
    required this.streakDays,
  });
  
  // Method to create a copy with new values (for state updates)
  Learner copyWith({
    String? name,
    String? location,
    String? learningGoal,
  }) {
    return Learner(
      name: name ?? this.name,
      title: title,
      imageUrl: imageUrl,
      location: location ?? this.location,
      preferredLanguage: preferredLanguage,
      learningGoal: learningGoal ?? this.learningGoal,
      overallProgress: overallProgress,
      // currentPrograms: currentPrograms,
      completedPrograms: completedPrograms,
      achievements: achievements,
      streakDays: streakDays,
    );
  }
}

// --- NEW Certificate Data Model ---
class Certificate {
  final String id;
  final String courseTitle;
  final DateTime dateEarned;
  final String certificateUrl;

  Certificate({
    required this.id,
    required this.courseTitle,
    required this.dateEarned,
    required this.certificateUrl,
  });
}

// --- NEW Mock Certificate Data ---
final List<Certificate> mockCertificates = [
  Certificate(
    id: 'CS001-2024-01',
    courseTitle: 'Fundamentals of UI/UX Design Principles',
    dateEarned: DateTime(2024, 1, 15),
    certificateUrl: 'https://mock-url/ui-ux-cert.pdf',
  ),
  Certificate(
    id: 'JS002-2024-03',
    courseTitle: 'Advanced Backend Development with TypeScript',
    dateEarned: DateTime(2024, 3, 22),
    certificateUrl: 'https://mock-url/typescript-backend-cert.pdf',
  ),
  Certificate(
    id: 'REACT-003-2024-06',
    courseTitle: 'Mastering State in Flutter Applications',
    dateEarned: DateTime(2024, 6, 10),
    certificateUrl: 'https://mock-url/flutter-state-cert.pdf',
  ),
];

// Mock Data
final Learner initialMockLearner = Learner(
  name: 'Alex Johnson',
  title: 'Aspiring Web Developer',
  imageUrl: 'assets/img/user.jpg',
  location: 'Nairobi, Kenya',
  preferredLanguage: 'English (US)',
  learningGoal: 'Master Full-Stack Development (MERN Stack)',
  overallProgress: 0.65, // 65% complete
  // currentPrograms: [
  //   Program(title: 'Introduction to React & State Management', progress: 0.75),
  //   Program(title: 'Node.js Backend Basics', progress: 0.30),
  // ],
  completedPrograms: [
    Program(title: 'Fundamentals of HTML & CSS', progress: 1.0, isCompleted: true),
    Program(title: 'JavaScript ES6 Essentials', progress: 1.0, isCompleted: true),
  ],
  achievements: [
    Achievement(title: 'First Course', description: 'Finished a program.', icon: Icons.star_outline, color: streakOrange),
    Achievement(title: '30-Day Streak', description: 'Maintained learning streak.', icon: Icons.local_fire_department_outlined, color: streakOrange),
    Achievement(title: 'Top Learner', description: 'Scored high in the JavaScript module.', icon: Icons.emoji_events_outlined, color: vibrantCyan),
  ],
  streakDays: 45,
);


/// Custom header with gradient and circular progress.
Widget _buildProfileHeader(BuildContext context, Learner learner, VoidCallback onEditTap) {
  return Container(
    padding: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: deepIndigo, // Fallback color
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      boxShadow: [
        BoxShadow(
          color: deepIndigo.withAlpha((0.4 * 255).toInt()),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        // App Bar Area with Edit Button
        // AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        //     onPressed: () => Navigator.pop(context), // Added actual back navigation
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.edit_outlined, color: Colors.white), // EDIT button
        //       onPressed: onEditTap, 
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.settings, color: Colors.white),
        //       onPressed: () {
        //         logger.i('Settings button tapped.');
        //         Navigator.push(context, MaterialPageRoute(builder: (context) => const _PlaceholderScreen(title: 'Settings')));
        //       },
        //     ),
        //   ],
        // ),
        
        // Profile Info
        const Padding(padding: EdgeInsetsGeometry.all(15.0)),
        Stack(
          alignment: Alignment.center,
          children: [
            // Circular Progress Indicator
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: learner.overallProgress,
                strokeWidth: 8,
                backgroundColor: deepIndigo.withAlpha((0.5 * 255).toInt()),
                valueColor: const AlwaysStoppedAnimation<Color>(vibrantCyan),
              ),
            ),
            // Profile Image
            CircleAvatar(
              radius: 54,
              backgroundColor: cardBackground, // White ring around image
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(learner.imageUrl),
                backgroundColor: vibrantCyan.withAlpha((0.1 * 255).toInt()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          learner.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: vibrantCyan,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${(learner.overallProgress * 100).round()}% Completed',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Helper function to build a section header
Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
  return Padding(
    padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800, // Extra bold for emphasis
            color: Colors.black87,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All', style: TextStyle(color: deepIndigo, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
      ],
    ),
  );
}

/// Widget for displaying a single piece of profile information in a clean tile.
Widget _buildInfoTile({
  required IconData icon,
  required String label,
  required String value,
  Color iconColor = deepIndigo,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: darkGreyText,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Widget for a single program progress item with a clean progress bar.
// Widget _buildProgramProgressItem(Program program) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 program.title,
//                 style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Text(
//               '${(program.progress * 100).round()}%',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: program.progress == 1.0 ? successGreen : deepIndigo),
//             ),
//           ],
//         ),
//         const SizedBox(height: 5),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(5),
//           child: LinearProgressIndicator(
//             value: program.progress,
//             backgroundColor: lightBackground,
//             valueColor: AlwaysStoppedAnimation<Color>(program.progress == 1.0 ? successGreen : vibrantCyan),
//             minHeight: 8,
//           ),
//         ),
//       ],
//     ),
//   );
// }

/// Widget for displaying a single achievement badge with shadow.
Widget _buildAchievementBadge(Achievement achievement) {
  return SizedBox(
    width: 100, // Fixed width for clean alignment
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: achievement.color.withAlpha((0.3 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(achievement.icon, color: achievement.color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          achievement.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    ),
  );
}

/// Widget for the Learning Streak indicator (Bold/Contrasting).
Widget _buildStreakCard(int days) {
  return Container(
    decoration: BoxDecoration(
      color: streakOrange,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: streakOrange.withAlpha((0.4 * 255).toInt()),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    padding: const EdgeInsets.all(18.0),
    child: Row(
      children: [
        const Icon(Icons.local_fire_department, color: Colors.white, size: 36),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔥 $days Days Streak',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Keep the momentum going!',
              style: TextStyle(
                color: Colors.white.withAlpha((0.8 * 255).toInt()),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(Icons.chevron_right, color: Colors.white, size: 30),
      ],
    ),
  );
}

/// Widget for a setting/preference tile (Flat design with padding).
Widget _buildActionTile({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  String? trailingText,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    decoration: BoxDecoration(
      color: cardBackground,
      borderRadius: BorderRadius.circular(12),
      // border: Border.all(color: borderGrey, width: 0.5),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Icon(Icons.chevron_right, color: darkGreyText.withAlpha((0.6 * 255).toInt())),
        ],
      ),
      onTap: onTap,
    ),
  );
}

// -----------------------------------------------------------------------------
// 2. Main Profile Screen (Stateful)
// -----------------------------------------------------------------------------

class LearnerProfileScreen extends StatefulWidget {
  const LearnerProfileScreen({super.key});

  @override
  State<LearnerProfileScreen> createState() => _LearnerProfileScreenState();
}

class _LearnerProfileScreenState extends State<LearnerProfileScreen> {
  // Use a state variable for the learner data
  Learner _learner = initialMockLearner;

  // Controllers for the edit dialog
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current learner data
    _nameController = TextEditingController(text: _learner.name);
    _locationController = TextEditingController(text: _learner.location);
    _goalController = TextEditingController(text: _learner.learningGoal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // Function to update learner data
  void _updateLearnerDetails({String? name, String? location, String? goal}) {
    setState(() {
      _learner = _learner.copyWith(
        name: name,
        location: location,
        learningGoal: goal,
      );
      // Also update controllers immediately if the change came from external source (though here it's local)
      _nameController.text = _learner.name;
      _locationController.text = _learner.location;
      _goalController.text = _learner.learningGoal;
      logger.i('Learner profile updated: Name=${_learner.name}, Location=${_learner.location}');
    });
  }

  // --- Functionality: Edit Profile Dialog ---
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: _goalController,
                  decoration: const InputDecoration(labelText: 'Learning Goal'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: darkGreyText)),
              onPressed: () {
                // Reset controllers to original values if cancelled
                _nameController.text = _learner.name;
                _locationController.text = _learner.location;
                _goalController.text = _learner.learningGoal;
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: deepIndigo),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _updateLearnerDetails(
                  name: _nameController.text.trim(),
                  location: _locationController.text.trim(),
                  goal: _goalController.text.trim(),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile details saved successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // --- Functionality: Mock Logout ---
  void _handleLogout() {
    logger.i('User initiated logout.');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logging out... Thank you for learning with us!')),
    );
    // In a real app, this would call Firebase/Auth service to sign out
    // Here, we just pop the screen to mock exiting the profile view.
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: CustomScrollView(
        slivers: [
          // 1. Profile Header (Sliver for the gradient effect)
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: false,
            backgroundColor: deepIndigo,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              // Pass the callback to the header to enable editing
              background: _buildProfileHeader(context, _learner, _showEditProfileDialog),
            ),
          ),
          
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // -----------------------------------------------------------------
                      // A. BASIC INFORMATION
                      // -----------------------------------------------------------------
                      _buildSectionHeader('Basic Information'),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              _buildInfoTile(
                                icon: Icons.track_changes_outlined,
                                label: 'Learning Goal',
                                value: _learner.learningGoal, // Updated from state
                                iconColor: vibrantCyan,
                              ),
                              const Divider(height: 1, color: borderGrey, indent: 40, endIndent: 10),
                              _buildInfoTile(
                                icon: Icons.location_on_outlined,
                                label: 'Location',
                                value: _learner.location, // Updated from state
                                iconColor: deepIndigo.withAlpha((0.8 * 255).toInt()),
                              ),
                            ],
                          ),
                        ),
                      ),


                      // Achievements (Grid of badges)
                      _buildSectionHeader('Achievements'),
                      

                      // -----------------------------------------------------------------
                      // C. PERSONALIZED DASHBOARD
                      // -----------------------------------------------------------------
                      // _buildSectionHeader('Your Dashboard'),
                      // Streak is outside the main card for visual emphasis
                      

                      _buildStreakCard(_learner.streakDays),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _learner.achievements.map((a) => _buildAchievementBadge(a)).toList(),
                        ),
                      ),

                      // -----------------------------------------------------------------
                      // B. LEARNING PROGRESS
                      // -----------------------------------------------------------------
                      // _buildSectionHeader('Current Progress'),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ..._learner.currentPrograms.map((p) => _buildProgramProgressItem(p)),
                              
                              //const Divider(height: 30, color: borderGrey),
                              
                              _buildActionTile(
                                title: 'Certificates Earned',
                                icon: Icons.verified_user_outlined,
                                color: successGreen,
                                onTap: () {
                                   logger.i('Navigating to Certificates.');
                                   Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CertificatesScreen()));
                                },
                                trailingText: '${_learner.completedPrograms.length}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      


                      _buildSectionHeader('Engagement'),

                      // Saved Lessons & Notifications grouped in one card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                        child: Column(
                          children: [
                            _buildActionTile(
                              title: 'Notifications',
                              icon: Icons.notifications_none,
                              color: streakOrange,
                              onTap: () {
                                 logger.i('Navigating to Notifications.');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationsScreen()));
                              },
                              trailingText: '3 New',
                            ),
                            _buildActionTile(
                              title: '1-on-1 Bookings',
                              icon: Icons.calendar_month_outlined,
                              color: successGreen,
                              onTap: () {
                                 logger.i('Navigating to 1-on-1 Bookings.');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const BookingsScreen()));
                              },
                              trailingText: '2 Books',
                            ),
                            _buildActionTile(
                              title: 'My Questions',
                              icon: Icons.question_mark_outlined,
                              color: darkGreyText,
                              onTap: () {
                                 logger.i('Navigating to My Public Questions');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const QuestionsScreen()));
                              },
                              trailingText: '25 Total',
                            ),
                          ],
                        ),
                      ),


                      _buildSectionHeader('Storage'),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                        child: Column(
                          children: [
                            _buildActionTile(
                              // title: 'Saved Lessons & Bookmarks',
                              title: 'File Manager',
                              icon: Icons.storage_outlined,
                              color: deepIndigo,
                              onTap: () {
                                 logger.i('Navigating to File Manager.');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FileManagerScreen()));
                              },
                              trailingText: '0.7/2 GB',
                            ),
                          ],
                        ),
                      ),

                      // -----------------------------------------------------------------
                      // D. SETTINGS AND PREFERENCES
                      // -----------------------------------------------------------------
                      _buildSectionHeader('Settings and Preferences'),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                        child: Column(
                          children: [
                            _buildActionTile(
                              title: 'Change Password',
                              icon: Icons.password_outlined,
                              color: deepIndigo,
                              onTap: () {
                                 logger.i('Navigating to Account Settings.');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ChangePasswordScreen()));
                              },
                            ),
                            _buildActionTile(
                              title: '2FA Authentication',
                              icon: Icons.key_outlined,
                              color: deepIndigo,
                              onTap: () {
                                 logger.i('Navigating to "FA Authentication.');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TwoFactorAuthScreen()));
                              },
                            ),
                            _buildActionTile(
                              title: 'Notification Preferences',
                              icon: Icons.notifications_active_outlined,
                              color: deepIndigo,
                              onTap: () {
                                 logger.i('Navigating to Notification Preferences.');
                                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const _PlaceholderScreen(title: 'Notification Preferences')));
                              },
                            ),
                          ],
                        ),
                      ),

                      
                      _buildActionTile(
                        title: 'Logout',
                        icon: Icons.logout,
                        color: redAccent,
                        onTap: _handleLogout, // Actual logout function
                        trailingText: '', // No trailing text for Logout
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. Placeholder Screen for Mock Navigation
// -----------------------------------------------------------------------------

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: deepIndigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You navigated to the "$title" screen.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: darkGreyText),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: vibrantCyan, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


// -----------------------------------------------------------------------------
// 3. Certificate Screen Components (NEWLY ADDED)
// -----------------------------------------------------------------------------

/// Formats a DateTime object into 'Month D, YYYY' format without external packages.
String _formatDate(DateTime date) {
  const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final month = monthNames[date.month - 1];
  final day = date.day;
  final year = date.year;
  return '$month $day, $year';
}

/// Card widget to display a single earned certificate with a premium look.
class CertificateCard extends StatelessWidget {
  final Certificate certificate;

  const CertificateCard({super.key, required this.certificate});

  void _downloadCertificate(BuildContext context) async {
    logger.i('Attempting to download certificate ID: ${certificate.id}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preparing download for "${certificate.courseTitle}"...'),
        duration: const Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Download Complete! Check your downloads for ${certificate.id}.pdf'),
          backgroundColor: successGreen,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(certificate.dateEarned);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha((0.08 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        color: cardBackground,
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header/Ribbon Area
              const Row(
                children: [
                  Icon(Icons.military_tech_rounded, color: vibrantCyan, size: 30),
                  SizedBox(width: 12),
                  Text(
                    'VERIFIED ACHIEVEMENT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: darkGreyText,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const Divider(height: 25, color: Color(0xFFE0E0E0)),
  
              // Course Title
              Text(
                certificate.courseTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: deepIndigo,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 18),
  
              // Details Row (Date and ID)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: darkGreyText.withAlpha((0.7 * 255).toInt())),
                  const SizedBox(width: 6),
                  Text(
                    'Earned: $formattedDate',
                    style: const TextStyle(fontSize: 14, color: darkGreyText, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    'ID: ${certificate.id}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: darkGreyText.withAlpha((0.6 * 255).toInt())),
                  ),
                ],
              ),
              const SizedBox(height: 25),
  
              // Download Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _downloadCertificate(context),
                  icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                  label: const Text(
                    'Download Certificate',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepIndigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 6,
                    shadowColor: deepIndigo.withAlpha((0.4 * 255).toInt()),
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
