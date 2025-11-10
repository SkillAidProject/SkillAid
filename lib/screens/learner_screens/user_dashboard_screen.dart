import 'package:flutter/material.dart';
import 'package:skillaid/screens/learner_screens/mentorship_screen.dart';
import 'package:skillaid/screens/learner_screens/profile_screen.dart';
import 'programs_screen.dart';
import 'program_details_screen.dart';

// --- Color and Style Definitions based on Screenshots ---
const Color primaryBlue = Color(0xFF1E88E5);
const Color darkPrimaryBlue = Color(0xFF1565C0);
const Color primaryGreen = Color(0xFF4CAF50); // Used for "Complete" status/tag
const Color accentYellow = Color(0xFFFDD835); // Star rating color
const Color accentOrange = Color(0xFFFF9800); // Notification banner color
const Color lightGreyBackground = Color(0xFFF5F5F5); // Overall scaffold background
const Color cardBackground = Colors.white; 
const Color darkGreyText = Color(0xFF5A5A5A); // Subtitle and body text

// --- Data Model for Courses (Enhanced for Screenshot Details) ---
class Course {
  final String title;
  final String description;
  final String tag;
  final String imageUrl;
  final double progress; // 0.0 to 1.0
  final String mentorName;
  final double rating;
  final bool hasVideo;
  final bool hasAudio;
  final bool hasText;

  Course({
    required this.title,
    required this.description,
    required this.tag,
    required this.imageUrl,
    required this.progress,
    required this.mentorName,
    required this.rating,
    required this.hasVideo,
    required this.hasAudio,
    required this.hasText,
  });
}

// --- MOCK DATA FOR COURSE DETAIL SCREEN CURRICULUM ---
class Lesson {
  final String title;
  final String duration; // e.g., "15 min"
  final IconData icon;
  final bool isCompleted;

  Lesson({
    required this.title,
    required this.duration,
    required this.icon,
    this.isCompleted = false,
  });
}

// Mock Curriculum data using existing course titles
final Map<String, List<Lesson>> mockCurriculums = {
  'Communication Skills': [
    Lesson(title: 'Module 1: Core Concepts & Tone', duration: '12 min', icon: Icons.videocam, isCompleted: true),
    Lesson(title: 'Module 2: Active Listening Techniques', duration: '15 min', icon: Icons.headset_mic, isCompleted: true),
    Lesson(title: 'Module 3: Non-Verbal Cues', duration: '10 min', icon: Icons.description, isCompleted: false),
    Lesson(title: 'Module 4: Conflict Resolution', duration: '30 min', icon: Icons.videocam, isCompleted: false),
    Lesson(title: 'Module 5: Feedback & Coaching', duration: '25 min', icon: Icons.headset_mic, isCompleted: false),
  ],
  'Web Development Basics': [
    Lesson(title: 'Introduction to HTML5', duration: '20 min', icon: Icons.videocam, isCompleted: false),
    Lesson(title: 'Basic CSS Styling', duration: '15 min', icon: Icons.description, isCompleted: false),
    Lesson(title: 'Working with JavaScript Functions', duration: '35 min', icon: Icons.videocam, isCompleted: false),
  ],
  'Effective Email Writing': [
    Lesson(title: 'The Perfect Subject Line', duration: '8 min', icon: Icons.description, isCompleted: false),
    Lesson(title: 'Structuring Professional Emails', duration: '10 min', icon: Icons.headset_mic, isCompleted: false),
  ],
  'Advanced Data Science': [
    Lesson(title: 'Deep Learning Introduction', duration: '45 min', icon: Icons.videocam, isCompleted: false),
    Lesson(title: 'Cloud Computing Integration', duration: '30 min', icon: Icons.description, isCompleted: false),
  ],
  'Time Management': [
    Lesson(title: 'The Pomodoro Technique', duration: '10 min', icon: Icons.headset_mic, isCompleted: false),
    Lesson(title: 'Eisenhower Matrix', duration: '15 min', icon: Icons.description, isCompleted: false),
  ],
  'Negotiation Mastery': [
    Lesson(title: 'BATNA & ZOPA', duration: '20 min', icon: Icons.videocam, isCompleted: false),
    Lesson(title: 'Dealing with High-Stakes Talks', duration: '25 min', icon: Icons.headset_mic, isCompleted: false),
  ],
};


// --- Mock Data that Matches the Screenshot Content and Structure ---
final List<Course> mockCourses = [
  // Dashboard Home View Courses
  Course(
    title: 'Communication Skills',
    description: 'Master the art of clear, concise, and persuasive communication in professional settings.',
    tag: 'Soft Skills',
    imageUrl: 'assets/img/comm.png',
    progress: 0.60, // In progress
    mentorName: 'Dr. Jane Smith',
    rating: 4.8,
    hasVideo: true,
    hasAudio: true,
    hasText: true,
  ),
  Course(
    title: 'Web Development Basics',
    description: 'An introductory course to front-end web development, covering HTML, CSS, and basic JavaScript.',
    tag: 'Technical',
    imageUrl: 'assets/img/webdev.png',
    progress: 0.0,
    mentorName: 'Prof. Alex Jones',
    rating: 4.5,
    hasVideo: true,
    hasAudio: false,
    hasText: true,
  ),
  Course(
    title: 'Effective Email Writing',
    description: 'Learn to compose professional, impactful, and efficient emails. Focuses on tone, structure, and subject lines.',
    tag: 'Soft Skills',
    imageUrl: 'assets/img/email.jpg',
    progress: 0.0,
    mentorName: 'Ms. Emily Clark',
    rating: 4.9,
    hasVideo: false,
    hasAudio: true,
    hasText: true,
  ),

  // Additional courses for the Programs/Explore Screen
  Course(
    title: 'Advanced Data Science',
    description: 'Deep dive into machine learning algorithms and cloud computing with Python.',
    tag: 'Technical',
    imageUrl: 'assets/img/datasci.jpg',
    progress: 0.0,
    mentorName: 'Dr. Sarah Lee',
    rating: 4.7,
    hasVideo: true,
    hasAudio: false,
    hasText: true,
  ),
  Course(
    title: 'Time Management',
    description: 'Boost productivity and beat procrastination with proven scheduling techniques.',
    tag: 'Soft Skills',
    imageUrl: 'assets/img/time.png',
    progress: 0.0,
    mentorName: 'Mr. David Chen',
    rating: 4.3,
    hasVideo: true,
    hasAudio: true,
    hasText: false,
  ),
  Course(
    title: 'Negotiation Mastery',
    description: 'Essential strategies for achieving win-win outcomes in business and life.',
    tag: 'Soft Skills',
    imageUrl: 'assets/img/nego.png',
    progress: 0.0,
    mentorName: 'Ms. Rachel Green',
    rating: 5.0,
    hasVideo: true,
    hasAudio: true,
    hasText: true,
  ),
];


// --- Custom Detailed Course Card (Matching Screenshot) ---
class DetailedCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const DetailedCourseCard({required this.course, required this.onTap, super.key});

  // Helper to get the correct progress status text
  String _getProgressStatus(double progress) {
    if (progress >= 1.0) return 'Complete';
    if (progress > 0.0) return '${(progress * 100).toInt()}% In Progress';
    return 'Not Started';
  }

  // Helper to get the tag background color (similar to screenshot)
  Color _getTagBackgroundColor(String tag) {
    if (tag == 'Soft Skills') return const Color(0xFFE3F2FD); // Light blue
    if (tag == 'Technical') return const Color(0xFFFFFDE7); // Very light yellow
    return lightGreyBackground;
  }
  
  // Helper to display the star rating
  Widget _buildRatingRow(double rating) {
    return Row(
      children: [
        const Icon(Icons.star, color: accentYellow, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkGreyText,
          ),
        ),
      ],
    );
  }

  // Helper to build the content features icon
  Widget _buildFeatureIcon({required bool isAvailable, required IconData icon}) {
    // Only display the icon if available, as seen in the screenshots
    if (!isAvailable) return const SizedBox.shrink(); 

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        icon,
        color: darkGreyText.withAlpha((0.7 * 255).toInt()),
        size: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isInProgress = course.progress > 0.0 && course.progress < 1.0;
    final String buttonText = isInProgress ? 'Continue' : 'Start Learning';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Header with Tag ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    course.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Placeholder for when the mock URL fails
                    errorBuilder: (context, error, stackTrace) {
                       return Container(
                        height: 140,
                        width: double.infinity,
                        color: darkGreyText.withAlpha((0.1 * 255).toInt()),
                        alignment: Alignment.center,
                        child: Text(course.tag, style: const TextStyle(color: darkGreyText)),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTagBackgroundColor(course.tag),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.tag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: darkPrimaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- Content Body ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Mentor and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mentor/Owner
                      Row(
                        children: [
                          Icon(Icons.person, color: darkGreyText.withAlpha((0.7 * 255).toInt()), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            course.mentorName,
                            style: const TextStyle(fontSize: 13, color: darkGreyText),
                          ),
                        ],
                      ),
                      
                      // Rating
                      _buildRatingRow(course.rating),
                    ],
                  ),
                  const Divider(height: 20),

                  // Progress Bar & Status (only visible for in-progress courses in this spot)
                  if (isInProgress) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getProgressStatus(course.progress),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                        // Content Icons (Video, Audio, Text) - positioned on the right
                        Row(
                          children: [
                            _buildFeatureIcon(isAvailable: course.hasVideo, icon: Icons.videocam),
                            _buildFeatureIcon(isAvailable: course.hasAudio, icon: Icons.headset_mic),
                            _buildFeatureIcon(isAvailable: course.hasText, icon: Icons.description),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: course.progress,
                      backgroundColor: lightGreyBackground,
                      valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Content Icons for Not Started course (or general explore view)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildFeatureIcon(isAvailable: course.hasVideo, icon: Icons.videocam),
                        _buildFeatureIcon(isAvailable: course.hasAudio, icon: Icons.headset_mic),
                        _buildFeatureIcon(isAvailable: course.hasText, icon: Icons.description),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
}

// --- Reusable Info Card (Downloaded / Mentorship) ---
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryBlue.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryBlue, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: darkGreyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  bool _isBannerVisible = true;
  
  void _navigateToCourseDetail(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Course? continueLearningCourse =mockCourses.isNotEmpty
      ? mockCourses.firstWhere(
        (c) => c.progress > 0.0 && c.progress < 1.0,
        orElse: () => mockCourses[0], 
      )
      
      : null;
    final List<Course> availableSkills = mockCourses.where((c) => c.progress == 0.0).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120.0,
          automaticallyImplyLeading: false,
          floating: true,
          pinned: false,
          backgroundColor: primaryBlue,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: primaryBlue,
              padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hi Emmanuel', 
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('👋', style: TextStyle(fontSize: 26)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Explore all available skills', 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),

        if (_isBannerVisible)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: accentOrange.withAlpha((0.15 * 255).toInt()), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentOrange.withAlpha((0.5 * 255).toInt()), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.rocket_launch_outlined, color: accentOrange, size: 24), 
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'New programs launched! Check out new *Courses* section in the Programs tab.',
                        style: TextStyle(fontSize: 14, color: Color(0xFFC67600)), 
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFC67600), size: 18),
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() => _isBannerVisible = false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continue Learning',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (continueLearningCourse != null)
                      DetailedCourseCard(
                        course: continueLearningCourse, 
                        onTap: () => _navigateToCourseDetail(continueLearningCourse),
                      ),
                    const SizedBox(height: 30),

                    const Text(
                      'Available Skills',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...availableSkills.map((course) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DetailedCourseCard(
                        course: course,
                        onTap: () => _navigateToCourseDetail(course),
                      ),
                    )),
                    
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            icon: Icons.download_for_offline_outlined,
                            title: 'Downloaded',
                            subtitle: '3 lessons',
                            onTap: () => debugPrint('View Downloaded lessons'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InfoCard(
                            icon: Icons.group_outlined,
                            title: 'Mentorship',
                            subtitle: 'View progress',
                            onTap: () => debugPrint('View Mentorship progress'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}







class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),        
    const ProgramsScreen(),      
    const MentorsScreen(), 
    const LearnerProfileScreen(),     
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyBackground,
      body: _widgetOptions.elementAt(_selectedIndex), 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: cardBackground,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // Updated icon to match the 'Programs' label intent
            icon: Icon(Icons.local_library_outlined), 
            activeIcon: Icon(Icons.local_library),
            label: 'Programs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Mentorship',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// A wrapper needed to run the single screen as a full app
void main() {
  runApp(const SkillAidApp());
}

class SkillAidApp extends StatelessWidget {
  const SkillAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    // For demonstration, let's start directly on the Program Details screen 
    // for a course that supports all modalities, to show the buttons working.
    // final initialCourse = mockCourses[0]; 

    return MaterialApp(
      title: 'SkillAid Dashboard Replica',
      theme: ThemeData(
        useMaterial3: true, 
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: lightGreyBackground,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // The home is set back to the main Dashboard for full navigation context.
      home: const DashboardScreen(), 
    );
  }
}
