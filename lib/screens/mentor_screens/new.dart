import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:skillaid/screens/mentor_screens/reschedule_session_screen.dart';

final logger = Logger();

// --- Common Color and Style Definitions ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF0F4F8); // Softer Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color borderGrey = Color(0xFFE0E0E0);
const Color redAccent = Color(0xFFE53935); // For End Call button
const Color successGreen = Color(0xFF4CAF50); // For Session status
const Color warningOrange = Color(0xFFFF9800); // For tech issues/warnings
const Color callBackground = Color(0xFF2C3E50); // Dark background for video feeds
const Color actionOrange = Color(0xFFFF9800);
const Color neutralBlue = Color(0xFF64B5F6);
const Color shadowColor = Color(0xFFC5C6D0);

// --- Combined Data Models ---

enum SessionType { video, audio, chat }
enum SessionState { lobby, inCall, postCall }

class Learner {
  final String name;
  final String photoUrl;
  Learner({required this.name, required this.photoUrl});
}

class SessionDetails {
  final Learner learner;
  final String skillTopic;
  final DateTime scheduledTime;
  final Duration duration;
  final SessionType type;

  SessionDetails({
    required this.learner,
    required this.skillTopic,
    required this.scheduledTime,
    required this.duration,
    required this.type,
  });
}

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

// --- Combined Mock Data ---
final mockSession = SessionDetails(
  learner: Learner(
    name: 'Alex Johnson',
    photoUrl: 'https://placehold.co/100x100/3F51B5/FFFFFF?text=AJ',
  ),
  skillTopic: 'Introduction to Firebase Firestore',
  scheduledTime: DateTime.now().add(const Duration(seconds: 10)), // Starts in 10 seconds for demo
  duration: const Duration(minutes: 30),
  type: SessionType.video,
);

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

// ----------------------------------------------------------------------------
// Helper Widgets
// ----------------------------------------------------------------------------

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

// Custom animated button for "Join Now" with session type indicator
class AnimatedJoinButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isActive;
  final String sessionType;

  const AnimatedJoinButton({required this.onTap, required this.isActive, required this.sessionType, super.key});

  @override
  State<AnimatedJoinButton> createState() => _AnimatedJoinButtonState();
}

class _AnimatedJoinButtonState extends State<AnimatedJoinButton> {
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
// 1. Mentor Dashboard Screen
// ----------------------------------------------------------------------------

class MentorDashboardScreen extends StatefulWidget {
  const MentorDashboardScreen({super.key});

  @override
  State<MentorDashboardScreen> createState() => _MentorDashboardScreenState();
}

class _MentorDashboardScreenState extends State<MentorDashboardScreen> {
  late Timer _timer;
  Duration _nextSessionTimeRemaining = const Duration();
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    String screenName = ['Home', 'Programs', 'Bookings', 'Mentees', 'Me'][index];
    logger.i('Navigating to $screenName');

    if (index != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceholderScreen(title: screenName)),
      ).then((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    }
  }

  // Helper Widgets for Dashboard
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

  SessionDetails _createLiveSession(Session dashSession) {
    return SessionDetails(
      learner: Learner(
        name: dashSession.learnerName,
        photoUrl: 'https://placehold.co/100x100/3F51B5/FFFFFF?text=${dashSession.learnerName.substring(0,2)}',
      ),
      skillTopic: dashSession.skillTopic,
      scheduledTime: dashSession.dateTime,
      duration: const Duration(minutes: 30),
      type: _convertSessionType(dashSession.sessionType),
    );
  }

  SessionType _convertSessionType(String type) {
    switch (type) {
      case 'video': return SessionType.video;
      case 'audio': return SessionType.audio;
      case 'chat': return SessionType.chat;
      default: return SessionType.video;
    }
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
                AnimatedJoinButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LiveSessionScreen(
                          session: _createLiveSession(session),
                        ),
                      ),
                    );
                  },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildHeader(context),
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
                _buildSectionTitle('Upcoming Sessions'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: mockUpcomingSessions.map(_buildUpcomingSessionCard).toList(),
                  ),
                ),
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }
}

// ----------------------------------------------------------------------------
// 2. Live Session Screen
// ----------------------------------------------------------------------------

class LiveSessionScreen extends StatefulWidget {
  final SessionDetails session;
  const LiveSessionScreen({super.key, required this.session});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  SessionState _currentState = SessionState.lobby;
  late Duration _sessionTimeRemaining;
  Timer? _timer;
  final TextEditingController _notesController = TextEditingController();
  bool _isMicOn = true;
  bool _isCameraOn = true;

  @override
  void initState() {
    super.initState();
    _startLobbyCountdown();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _startLobbyCountdown() {
    _sessionTimeRemaining = widget.session.scheduledTime.difference(DateTime.now());
    if (_sessionTimeRemaining.isNegative) {
      _sessionTimeRemaining = Duration.zero;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_sessionTimeRemaining.inSeconds > 0) {
          _sessionTimeRemaining = _sessionTimeRemaining - const Duration(seconds: 1);
        } else {
          timer.cancel();
          _currentState = SessionState.lobby;
        }
      });
    });
  }

  void _joinSession() {
    _timer?.cancel();
    setState(() {
      _currentState = SessionState.inCall;
      _sessionTimeRemaining = const Duration(seconds: 30); 
      _startSessionTimer();
    });
  }

  void _startSessionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_sessionTimeRemaining.inSeconds > 0) {
          _sessionTimeRemaining = _sessionTimeRemaining - const Duration(seconds: 1);
        } else {
          _endSession();
        }
      });
    });
  }

  void _endSession() {
    _timer?.cancel();
    setState(() {
      _currentState = SessionState.postCall;
    });
  }

  void _saveNotes() {
    logger.i('Notes saved: ${_notesController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session notes saved successfully.')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentState == SessionState.inCall
              ? 'Live Session: ${_formatDuration(_sessionTimeRemaining)}'
              : 'Live Session',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: _currentState == SessionState.inCall ? callBackground : deepIndigo,
        elevation: 0,
        automaticallyImplyLeading: _currentState == SessionState.lobby,
        actions: _currentState == SessionState.inCall
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Center(
                    child: Text(
                      'Time Left: ${_formatDuration(_sessionTimeRemaining)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: _buildBody(),
      backgroundColor: _currentState == SessionState.inCall ? callBackground : lightBackground,
    );
  }

  Widget _buildBody() {
    switch (_currentState) {
      case SessionState.lobby:
        return _buildLobbyScreen();
      case SessionState.inCall:
        return _buildInCallScreen();
      case SessionState.postCall:
        return _buildPostCallScreen();
    }
  }

  Widget _buildLobbyScreen() {
    final bool isReadyToJoin = _sessionTimeRemaining.inSeconds <= 0;
    final String countdownText = isReadyToJoin
        ? "Session is ready! Click 'Enter'."
        : "Session starts in ${_sessionTimeRemaining.inMinutes} minutes ${_sessionTimeRemaining.inSeconds % 60} seconds";

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: cardBackground,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.access_time_filled, size: 48, color: isReadyToJoin ? successGreen : vibrantCyan),
                      const SizedBox(height: 12),
                      Text(
                        countdownText,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isReadyToJoin ? successGreen : deepIndigo),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: isReadyToJoin ? _joinSession : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vibrantCyan,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor: vibrantCyan.withAlpha((0.4 * 255).toInt()),
                        ),
                        icon: const Icon(Icons.videocam, color: Colors.white),
                        label: Text(
                          'Enter Live Session',
                          style: TextStyle(
                              fontSize: 18,
                              color: isReadyToJoin ? Colors.white : Colors.white.withAlpha((0.6 * 255).toInt())),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: cardBackground,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Session Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: deepIndigo)),
                      const Divider(height: 20, color: borderGrey),
                      _buildDetailRow(
                        icon: Icons.person,
                        label: "Learner",
                        value: widget.session.learner.name,
                        isLearner: true,
                      ),
                      _buildDetailRow(
                        icon: Icons.menu_book,
                        label: "Topic",
                        value: widget.session.skillTopic,
                      ),
                      _buildDetailRow(
                        icon: Icons.calendar_month,
                        label: "Scheduled",
                        value: DateFormat('EEE, MMM d, h:mm a').format(widget.session.scheduledTime),
                      ),
                      _buildDetailRow(
                        icon: Icons.timer,
                        label: "Duration",
                        value: '${widget.session.duration.inMinutes} minutes',
                      ),
                      _buildDetailRow(
                        icon: _getSessionTypeIcon(widget.session.type),
                        label: "Type",
                        value: widget.session.type.name.toUpperCase(),
                        color: vibrantCyan,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: cardBackground,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tech Check',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: deepIndigo)),
                      const Divider(height: 20, color: borderGrey),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechPreview(
                              'Microphone',
                              _isMicOn ? Icons.mic : Icons.mic_off,
                              _isMicOn ? successGreen : redAccent,
                              _isMicOn ? 'Working' : 'Muted',
                              () => setState(() => _isMicOn = !_isMicOn),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTechPreview(
                              'Camera',
                              _isCameraOn ? Icons.videocam : Icons.videocam_off,
                              _isCameraOn ? successGreen : redAccent,
                              _isCameraOn ? 'Active' : 'Off',
                              () => setState(() => _isCameraOn = !_isCameraOn),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.signal_cellular_alt,
                        label: "Connection",
                        value: "Excellent",
                        color: successGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color color = darkGreyText,
    bool isLearner = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isLearner ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: deepIndigo),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, color: darkGreyText),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                if (isLearner) ...[
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(widget.session.learner.photoUrl),
                    backgroundColor: deepIndigo,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(color: color == darkGreyText ? Colors.black87 : color, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechPreview(
      String label, IconData icon, Color color, String status, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha((0.5 * 255).toInt()), width: 2),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(status, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  IconData _getSessionTypeIcon(SessionType type) {
    switch (type) {
      case SessionType.video:
        return Icons.videocam;
      case SessionType.audio:
        return Icons.mic;
      case SessionType.chat:
        return Icons.chat_bubble;
    }
  }

  Widget _buildInCallScreen() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: callBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.2 * 255).toInt()), blurRadius: 10)],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(widget.session.learner.photoUrl),
                                backgroundColor: deepIndigo,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.session.learner.name,
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              color: deepIndigo.withAlpha((0.8 * 255).toInt()),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _isCameraOn ? 'My Camera' : 'Camera Off',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: _isCameraOn ? FontWeight.normal : FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCallControl(
                        _isMicOn ? Icons.mic : Icons.mic_off,
                        _isMicOn ? 'Mute' : 'Unmute',
                        _isMicOn ? Colors.white : redAccent,
                        () => setState(() => _isMicOn = !_isMicOn),
                      ),
                      _buildCallControl(
                        _isCameraOn ? Icons.videocam : Icons.videocam_off,
                        _isCameraOn ? 'Camera Off' : 'Camera On',
                        _isCameraOn ? Colors.white : redAccent,
                        () => setState(() => _isCameraOn = !_isCameraOn),
                      ),
                      _buildCallControl(
                        Icons.screen_share,
                        'Share Screen',
                        Colors.white,
                        () {},
                        isPrimary: true,
                      ),
                      _buildCallControl(
                        Icons.chat_bubble_outline,
                        'Chat',
                        Colors.white,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chat box is now active.')),
                          );
                        },
                      ),
                      const Spacer(),
                      _buildCallControl(
                        Icons.call_end,
                        'End Session',
                        redAccent,
                        _endSession,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 300,
          color: cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Mentor Notes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: deepIndigo)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.save, color: vibrantCyan),
                      onPressed: _saveNotes,
                      tooltip: 'Save Notes',
                    ),
                  ],
                ),
                const Divider(height: 10),
                Expanded(
                  child: TextField(
                    controller: _notesController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Jot down key points, actions, or links here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: borderGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: vibrantCyan, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Topic: ${widget.session.skillTopic}',
                  style: const TextStyle(fontSize: 12, color: darkGreyText),
                ),
                Text(
                  'Learner: ${widget.session.learner.name}',
                  style: const TextStyle(fontSize: 12, color: darkGreyText),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCallControl(
      IconData icon, String label, Color color, VoidCallback onTap,
      {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              backgroundColor: isPrimary ? color : color.withAlpha((0.1 * 255).toInt()),
              foregroundColor: isPrimary ? Colors.white : color,
              elevation: 4,
            ),
            child: Icon(icon, size: 24, color: isPrimary ? Colors.white : color),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPostCallScreen() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(32),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle, size: 64, color: successGreen),
                const SizedBox(height: 20),
                const Text(
                  'Session Completed Successfully!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: deepIndigo),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Great job mentoring ${widget.session.learner.name} on "${widget.session.skillTopic}".',
                  style: const TextStyle(fontSize: 16, color: darkGreyText),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 40),
                _buildSummaryActionButton(
                  icon: Icons.edit_note,
                  label: 'Add/Review Session Notes',
                  description: 'Finalize the key takeaways and action items.',
                  color: vibrantCyan,
                  onPressed: () {
                    logger.i('Navigating to notes editing...');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notes editing screen (Mock)')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSummaryActionButton(
                  icon: Icons.task_alt,
                  label: 'Mark Session as Completed',
                  description: 'Confirm the session is officially finished.',
                  color: successGreen,
                  onPressed: () {
                    logger.i('Marking session as complete...');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Session marked completed!')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSummaryActionButton(
                  icon: Icons.link,
                  label: 'Suggest Follow-up Resources',
                  description: 'Send reading materials or next steps to the learner.',
                  color: warningOrange,
                  onPressed: () {
                    logger.i('Navigating to resource suggestions...');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resource suggestion tool (Mock)')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryActionButton(
      {required IconData icon,
      required String label,
      required String description,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.white.withAlpha((0.8 * 255).toInt()), fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Supporting Screens
// ----------------------------------------------------------------------------

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

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

// class MockBookingsListScreen extends StatelessWidget {
//   const MockBookingsListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reschedule Session'),
//         backgroundColor: deepIndigo,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Session Rescheduling Interface',
//               style: TextStyle(fontSize: 18, color: darkGreyText),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(backgroundColor: vibrantCyan),
//               child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ----------------------------------------------------------------------------
// Main App
// ----------------------------------------------------------------------------

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SkillAidApp());
}

class SkillAidApp extends StatelessWidget {
  const SkillAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillAid Mentor Platform',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: deepIndigo,
        scaffoldBackgroundColor: lightBackground,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: deepIndigo,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: vibrantCyan),
      ),
      home: const MentorDashboardScreen(),
      routes: {
        '/dashboard': (context) => const MentorDashboardScreen(),
        '/live-session': (context) => LiveSessionScreen(session: mockSession),
      },
    );
  }
}