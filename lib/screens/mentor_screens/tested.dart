import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:skillaid/screens/mentor_screens/reschedule_session_screen.dart';

final logger = Logger();

// --- Color and Style Definitions (Refined) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF0F4F8); // Softer Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50);
const Color actionOrange = Color(0xFFFF9800);
const Color neutralBlue = Color(0xFF64B5F6);
const Color shadowColor = Color(0xFFC5C6D0);

// --- Data Models (Updated with sessionType) ---

class Mentor {
  final String name;
  final String title;
  final String imageUrl;
  final double averageRating;
  final double totalMentees;
  final double sessionsCompleted;
  final double programsPublished;

  Mentor({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.averageRating,
    required this.totalMentees,
    required this.sessionsCompleted,
    required this.programsPublished,
  });
}

class Session {
  final String learnerName;
  final String skillTopic;
  final DateTime dateTime;
  final String sessionType; // 'video', 'audio', or 'chat'

  Session({
    required this.learnerName,
    required this.skillTopic,
    required this.dateTime,
    required this.sessionType,
  });
}

class Activity {
  final String description;
  final IconData icon;
  final Color color;
  final String timeAgo;

  Activity({
    required this.description,
    required this.icon,
    required this.color,
    required this.timeAgo,
  });
}

// --- Sample Data ---
final Mentor mockMentor = Mentor(
  name: 'Dr. Evelyn Reed',
  title: 'Senior Data Scientist',
  imageUrl: 'https://placehold.co/100x100/3F51B5/FFFFFF/png?text=ER',
  averageRating: 4.9,
  totalMentees: 145,
  sessionsCompleted: 48,
  programsPublished: 3,
);

final List<Session> mockUpcomingSessions = [
  Session(
    learnerName: 'Alex Johnson',
    skillTopic: 'Advanced Python Debugging',
    dateTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
    sessionType: 'video',
  ),
  Session(
    learnerName: 'Maria Lee',
    skillTopic: 'Cloud Deployment Strategies',
    dateTime: DateTime.now().add(const Duration(hours: 5, minutes: 15)),
    sessionType: 'audio',
  ),
  Session(
    learnerName: 'Ben Carter',
    skillTopic: 'Introduction to Angular',
    dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
    sessionType: 'chat',
  ),
];

final List<Activity> mockRecentActivity = [
  Activity(
    description: 'New session request from **Jessica Alba** for UX Design.',
    icon: Icons.schedule_outlined,
    color: vibrantCyan,
    timeAgo: '15m ago',
  ),
  Activity(
    description: 'Received positive feedback from **Alex Johnson** (5/5 stars!).',
    icon: Icons.star_rate_rounded,
    color: successGreen,
    timeAgo: '2h ago',
  ),
  Activity(
    description: 'New enrollment in your **React Mastery Program**.',
    icon: Icons.person_add_alt_1_outlined,
    color: neutralBlue,
    timeAgo: '6h ago',
  ),
];

// -----------------------------------------------------------------------------
// Helper Widgets
// -----------------------------------------------------------------------------

// Animated Counter for dynamic stats
class AnimatedCounter extends StatelessWidget {
  final double endValue;
  final TextStyle style;
  final int precision;

  const AnimatedCounter({required this.endValue, required this.style, this.precision = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: endValue.toDouble()),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (BuildContext context, double value, Widget? child) {
        String formattedValue;
        if (precision > 0) {
           formattedValue = value.toStringAsFixed(precision);
        } else {
          formattedValue = NumberFormat.compact().format(value.round());
        }
        return Text(formattedValue, style: style);
      },
    );
  }
}

// Simple Bar Indicator for Performance Insights
class InsightBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color color;

  const InsightBar({required this.value, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: color.withAlpha((0.15 * 255).toInt()),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                height: 8,
                width: constraints.maxWidth * value,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. Mentor Dashboard Screen
// -----------------------------------------------------------------------------

class MentorDashboardScreen extends StatefulWidget {
  const MentorDashboardScreen({super.key});

  @override
  State<MentorDashboardScreen> createState() => _MentorDashboardScreenState();
}

class _MentorDashboardScreenState extends State<MentorDashboardScreen> {
  late Timer _timer;
  Duration _nextSessionTimeRemaining = const Duration();

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _updateTimeRemaining();
    // Only update if there are upcoming sessions
    if (mockUpcomingSessions.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _updateTimeRemaining();
        }
      });
    }
  }

  void _updateTimeRemaining() {
    if (mockUpcomingSessions.isNotEmpty) {
      final now = DateTime.now();
      final nextSession = mockUpcomingSessions.first.dateTime;
      final remaining = nextSession.difference(now);
      setState(() {
        _nextSessionTimeRemaining = remaining > Duration.zero ? remaining : Duration.zero;
      });
    }
  }

  String _formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours.remainder(24)}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s';
    if (d.inSeconds > 0) return '${d.inSeconds.remainder(60)}s';
    return 'LIVE';
  }

  // bottom nav bar
  int _selectedIndex = 0; // Profile screen is the 4th item (index 3)

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    // Mock navigation logic
    String screenName = ['Home', 'Programs', 'Bookings', 'Mentees', 'Me'][index];
    logger.i('Navigating to $screenName');

    if (index != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _PlaceholderScreen(title: screenName)),
      ).then((_) {
        // Reset to this screen index after coming back from a mock screen
        // This is necessary because the other screens are mock.
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    }
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, left: 18.0, right: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: deepIndigo,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final upcomingCount = mockUpcomingSessions.where((s) => s.dateTime.day == DateTime.now().day).length;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [deepIndigo, Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x223F51B5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(mockMentor.imageUrl),
                backgroundColor: vibrantCyan,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${mockMentor.name.split(' ').first}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      mockMentor.title,
                      style: TextStyle(fontSize: 14, color: Colors.white.withAlpha((0.8 * 255).toInt())),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.notifications_none, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: vibrantCyan.withAlpha((0.8 * 255).toInt()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(
                  upcomingCount > 0
                      ? 'You have $upcomingCount upcoming sessions today.'
                      : 'No sessions scheduled for today.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double intValue,
    required double doubleValue,
    required IconData icon,
    required Color color,
    required bool isDouble,
  }) {
    return Expanded(
      child: Card(
        elevation: 8,
        shadowColor: shadowColor.withAlpha((0.5 * 255).toInt()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withAlpha((0.2 * 255).toInt()), width: 1.5),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 10),
              isDouble
                  ? AnimatedCounter(
                      endValue: doubleValue * 1,
                      precision: 1,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    )
                  : AnimatedCounter(
                      endValue: intValue,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: darkGreyText, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSessionCard(Session session) {
    bool isNext = session == mockUpcomingSessions.first && _nextSessionTimeRemaining > Duration.zero;
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: isNext ? 10 : 4,
      shadowColor: isNext ? vibrantCyan.withAlpha((0.6 * 255).toInt()) : shadowColor.withAlpha((0.4 * 255).toInt()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.learnerName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: deepIndigo),
                ),
                Text(
                  DateFormat('h:mm a, EEE').format(session.dateTime),
                  style: const TextStyle(fontSize: 13, color: darkGreyText),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              session.skillTopic,
              style: TextStyle(fontSize: 14, color: darkGreyText.withAlpha((0.8 * 255).toInt())),
            ),
            const Divider(height: 25, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isNext)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: actionOrange.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: actionOrange),
                    ),
                    child: Text(
                      _formatDuration(_nextSessionTimeRemaining),
                      style: const TextStyle(
                        color: actionOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                if (!isNext) const Spacer(),
                TextButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MockBookingsListScreen())),
                  icon: const Icon(Icons.edit_calendar, size: 18, color: darkGreyText),
                  label: const Text('Reschedule'),
                  style: TextButton.styleFrom(foregroundColor: darkGreyText),
                ),
                const SizedBox(width: 8),
                _AnimatedJoinButton(
                  onTap: () => logger.i('Joining session with ${session.learnerName}'),
                  isActive: isNext,
                  sessionType: session.sessionType,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionShortcut({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withAlpha((0.3 * 255).toInt()),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: darkGreyText),
            ),
          ],
        ),
      ),
    );
  }

  // --- NEW Minimalist Modern Bottom Navigation Bar ---
  Widget _buildCustomBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_filled, 'Home', 0),
              _navItem(Icons.local_library_outlined, 'Programs', 1),
              _navItem(Icons.calendar_month_outlined, 'Bookings', 2),
              _navItem(Icons.people_outline, 'Mentees', 3),
              _navItem(Icons.person_outline, 'Me', 4),
            ],
          ),
        ),
      ),
    );
  }

  // --- Individual Navigation Item (Helper for minimalist look) ---
  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = index == _selectedIndex;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? deepIndigo : darkGreyText.withAlpha((0.6 * 255).toInt()),
                size: isSelected ? 26 : 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? deepIndigo : darkGreyText.withAlpha((0.6 * 255).toInt()),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeedItem(Activity activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: activity.color.withAlpha((0.15 * 255).toInt()),
            child: Icon(activity.icon, color: activity.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.timeAgo,
                  style: TextStyle(fontSize: 12, color: darkGreyText.withAlpha((0.7 * 255).toInt())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInsight(String title, IconData icon, Color color, double value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shadowColor: shadowColor.withAlpha((0.4 * 255).toInt()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: darkGreyText, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              InsightBar(value: value, color: color),
              const SizedBox(height: 4),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(fontSize: 12, color: darkGreyText.withAlpha((0.9 * 255).toInt()), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // 1. Welcome Header
                _buildHeader(context),

                // 2. Quick Stats Overview
                _buildSectionTitle('Your Performance Snapshot'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      _buildStatCard(
                        title: 'Total Mentees',
                        intValue: mockMentor.totalMentees,
                        doubleValue: 0.0,
                        icon: Icons.people_alt_outlined,
                        color: neutralBlue,
                        isDouble: false,
                      ),
                      _buildStatCard(
                        title: 'Sessions Completed',
                        intValue: mockMentor.sessionsCompleted,
                        doubleValue: 0.0,
                        icon: Icons.check_circle_outline,
                        color: successGreen,
                        isDouble: false,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      _buildStatCard(
                        title: 'Avg. Rating',
                        intValue: 0,
                        doubleValue: mockMentor.averageRating,
                        icon: Icons.star_rate_rounded,
                        color: actionOrange,
                        isDouble: true,
                      ),
                      _buildStatCard(
                        title: 'Programs Published',
                        intValue: mockMentor.programsPublished,
                        doubleValue: 0.0,
                        icon: Icons.book_outlined,
                        color: deepIndigo,
                        isDouble: false,
                      ),
                    ],
                  ),
                ),

                // 3. Upcoming Sessions
                _buildSectionTitle('Upcoming Sessions'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: mockUpcomingSessions.map(_buildUpcomingSessionCard).toList(),
                  ),
                ),

                // 4. Action Shortcuts - UPDATED TO GRID LAYOUT
                _buildSectionTitle('Quick Actions'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.4,
                    children: [
                      _buildActionShortcut(
                        title: 'Create Program',
                        icon: Icons.library_add_check,
                        color: deepIndigo,
                        onTap: () => logger.i('Navigate to Create Program'),
                      ),
                      _buildActionShortcut(
                        title: 'Upload Lesson',
                        icon: Icons.upload_file,
                        color: vibrantCyan,
                        onTap: () => logger.i('Navigate to Upload Lesson'),
                      ),
                      _buildActionShortcut(
                        title: 'View Analytics',
                        icon: Icons.analytics,
                        color: successGreen,
                        onTap: () => logger.i('Navigate to Analytics'),
                      ),
                      _buildActionShortcut(
                        title: 'Answer Questions',
                        icon: Icons.quiz_outlined,
                        color: actionOrange,
                        onTap: () => logger.i('Navigate to Q&A'),
                      ),
                    ],
                  ),
                ),

                // 5. Recent Activity Feed
                _buildSectionTitle('Recent Activity Feed'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  elevation: 5,
                  shadowColor: shadowColor.withAlpha((0.4 * 255).toInt()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: mockRecentActivity.map(_buildActivityFeedItem).toList(),
                    ),
                  ),
                ),

                // 6. Performance Insights
                _buildSectionTitle('Deep Performance Insights'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      _buildPerformanceInsight('Engagement Trends', Icons.trending_up, vibrantCyan, 0.85),
                      const SizedBox(width: 10),
                      _buildPerformanceInsight('Rating Over Time', Icons.star_border, actionOrange, 0.98),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    children: [
                      _buildPerformanceInsight('Session Attendance', Icons.check_circle_outline, neutralBlue, 0.75),
                      const SizedBox(width: 10),
                      _buildPerformanceInsight('Learner Progress', Icons.bar_chart_outlined, successGreen, 0.90),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ],
      ),

      // 7. Bottom Navigation Bar
      // NEW Minimalist Modern Bottom Navigation Bar
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }
}


// ----------------------------------------------------------------------------
// 3. Placeholder Screen for Mock Navigation
// ----------------------------------------------------------------------------

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




// Custom animated button for "Join Now" with session type indicator
class _AnimatedJoinButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isActive;
  final String sessionType;

  const _AnimatedJoinButton({required this.onTap, required this.isActive, required this.sessionType});

  @override
  State<_AnimatedJoinButton> createState() => _AnimatedJoinButtonState();
}

class _AnimatedJoinButtonState extends State<_AnimatedJoinButton> {
  bool _isTapped = false;

  void _handleTapDown(_) {
    setState(() {
      _isTapped = true;
    });
  }

  void _handleTapUp(_) {
    setState(() {
      _isTapped = false;
    });
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() {
      _isTapped = false;
    });
  }

  // Helper method to get icon based on session type
  IconData _getSessionTypeIcon() {
    switch (widget.sessionType) {
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.mic;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.videocam;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isTapped ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: widget.isActive
                  ? [vibrantCyan, deepIndigo]
                  : [deepIndigo.withAlpha((0.5 * 255).toInt()), deepIndigo.withAlpha((0.7 * 255).toInt())],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: vibrantCyan.withAlpha((0.5 * 255).toInt()),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(_getSessionTypeIcon(), size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.isActive ? 'Join Live' : 'Join',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SkillAidMentorApp());
}

class SkillAidMentorApp extends StatelessWidget {
  const SkillAidMentorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillAid Mentor Dashboard',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: deepIndigo,
        scaffoldBackgroundColor: lightBackground,
        fontFamily: 'Roboto',
      ),
      home: const MentorDashboardScreen(),
    );
  }
}