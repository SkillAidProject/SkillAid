import 'package:flutter/material.dart';
import 'user_dashboard_screen.dart';


// --- NEW Data Model for Reviews ---
class Review {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}


// --- MOCK DATA FOR REVIEWS ---
final Map<String, List<Review>> mockReviews = {
  'Communication Skills': [
    Review(
      userName: 'Alice M.',
      rating: 5.0,
      comment: 'Absolutely fantastic course! Dr. Smith breaks down complex concepts into easy-to-digest modules. My confidence in professional conversations has skyrocketed.',
      date: DateTime(2025, 10, 25),
    ),
    Review(
      userName: 'Bob J.',
      rating: 4.0,
      comment: 'Very informative, especially the section on active listening. I wish there were more practical role-playing exercises, but overall a great resource.',
      date: DateTime(2025, 10, 18),
    ),
    Review(
      userName: 'Charlie D.',
      rating: 5.0,
      comment: 'A mandatory course for anyone starting their career. The content is immediately applicable and the mentor’s style is engaging.',
      date: DateTime(2025, 9, 10),
    ),
  ],
  'Web Development Basics': [
    Review(
      userName: 'Dev Guy',
      rating: 4.5,
      comment: 'Good starting point for HTML/CSS, but the JavaScript part felt a bit rushed. Solid foundation though.',
      date: DateTime(2025, 11, 1),
    ),
  ],
  'Advanced Data Science': [
    Review(
      userName: 'Tech Fan',
      rating: 5.0,
      comment: 'Incredibly detailed and current on the latest machine learning trends. The cloud integration module was a game-changer for my projects.',
      date: DateTime(2025, 11, 2),
    ),
  ],
  'Negotiation Mastery': [
    Review(
      userName: 'Executive L.',
      rating: 4.8,
      comment: 'Highly practical strategies for high-stakes talks. I used the BATNA framework in a meeting this week and got a great result.',
      date: DateTime(2025, 10, 15),
    ),
  ],
};



// --- NEW Review Card Widget ---
class ReviewCard extends StatelessWidget {
  final Review review;
  final Color accentYellow;
  final Color darkGreyText;

  const ReviewCard({
    required this.review,
    required this.accentYellow,
    required this.darkGreyText,
    super.key,
  });

  Widget _buildStarRating(double rating, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        // Use full star, half star, or border based on the rating value
        return Icon(
          index < rating.floor() ? Icons.star : 
          (index < rating && rating < (index + 1) ? Icons.star_half : Icons.star_border),
          color: color,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: darkGreyText.withAlpha((0.1 * 255).toInt()), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Text(
                // Formats date as D/M/YYYY
                '${review.date.day}/${review.date.month}/${review.date.year}',
                style: TextStyle(
                  fontSize: 12,
                  color: darkGreyText.withAlpha((0.6 * 255).toInt()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildStarRating(review.rating, accentYellow),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: darkGreyText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}


// -----------------------------------------------------------------
// ---------------------- NEW COURSE DETAIL SCREEN -----------------
// -----------------------------------------------------------------

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({required this.course, super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  // State to manage the selected accessibility mode (default to Video/Visual)
  // This state can be used later to filter content for blind (Audio/Text preferred) or deaf (Video/Text preferred) users.
  String _selectedMode = 'Video'; 

  // NEW: State for reviews and user input
  late List<Review> _reviews;
  double _newReviewRating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize reviews from mock data for the current course
    _reviews = List.from(mockReviews[widget.course.title] ?? []);
  }
  
  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Helper to display the star rating (copied from DetailedCourseCard)
  Widget _buildRatingRow(double rating, {Color color = Colors.white}) {
    return Row(
      children: [
        const Icon(Icons.star, color: accentYellow, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Helper widget for the accessibility buttons
  Widget _buildAccessibilityOptionButton({
    required IconData icon,
    required String label,
    required String mode,
    required bool isAvailable,
  }) {
    final bool isSelected = _selectedMode == mode;
    final Color iconColor = isSelected ? Colors.white : primaryBlue;
    final Color textColor = isSelected ? Colors.white : primaryBlue;
    final Color bgColor = isSelected ? primaryBlue : Colors.white.withAlpha((0.9 * 255).toInt());
    final Color borderColor = isSelected ? primaryBlue : darkGreyText.withAlpha((0.3 * 255).toInt());
    final Color disabledColor = darkGreyText.withAlpha((0.4 * 255).toInt());
    final bool isDisabled = !isAvailable;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: isDisabled 
            ? null 
            : () {
                setState(() {
                  _selectedMode = mode;
                });
                debugPrint('Accessibility mode selected: $mode');
              },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDisabled ? lightGreyBackground : bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDisabled ? lightGreyBackground : borderColor,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDisabled ? disabledColor : iconColor,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDisabled ? disabledColor : textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- REVIEW SUBMISSION LOGIC ---
  void _submitReview() {
    // Basic validation
    if (_newReviewRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating.')),
      );
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment for your review.')),
      );
      return;
    }

    final newReview = Review(
      userName: 'Current User (You)', // Mock user name
      rating: _newReviewRating,
      comment: _reviewController.text.trim(),
      date: DateTime.now(),
    );

    setState(() {
      _reviews.insert(0, newReview); // Add to the top
      _reviewController.clear();
      _newReviewRating = 0.0;
    });

    // In a real app, this would involve a database or API call.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Content for the Curriculum Tab
  Widget _buildCurriculumList() {
    final List<Lesson> lessons = mockCurriculums[widget.course.title] ?? [];

    if (lessons.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Curriculum details are not yet available for this program.'),
        ),
      );
    }

    // Since the selected mode is now managed by state, a real implementation would filter this list 
    // based on lessons tagged for 'Video', 'Audio', or 'Text' delivery.
    return ListView.builder(
      itemCount: lessons.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Column(
          children: [
            ListTile(
              leading: Icon(
                lesson.icon,
                color: lesson.isCompleted ? primaryGreen : primaryBlue.withAlpha((0.8 * 255).toInt()),
              ),
              title: Text(
                lesson.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: lesson.isCompleted ? darkGreyText : Colors.black87,
                  decoration: lesson.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                lesson.duration,
                style: TextStyle(color: darkGreyText.withAlpha((0.7 * 255).toInt())),
              ),
              trailing: lesson.isCompleted
                  ? const Icon(Icons.check_circle, color: primaryGreen)
                  : const Icon(Icons.lock_open, color: darkGreyText),
              onTap: () {
                // In a real app, this would start the lesson
                debugPrint('Tapped lesson: ${lesson.title}. Current mode: $_selectedMode');
              },
            ),
            const Divider(height: 1, indent: 72, endIndent: 16),
          ],
        );
      },
    );
  }

  // Helper for Description Tab bullet points
  Widget _buildTakeawayItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: darkGreyText),
            ),
          ),
        ],
      ),
    );
  }
  
  // Content for the Description Tab
  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this Program',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.course.description} The program includes quizzes, interactive coding challenges, and a final capstone project to solidify your understanding. Upon completion, you will receive a verifiable certificate.',
            style: const TextStyle(fontSize: 15, color: darkGreyText, height: 1.5),
          ),
          const SizedBox(height: 24),

          const Text(
            'Key Takeaways',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Simple bullet points for takeaways
          _buildTakeawayItem('Professional Certification', Icons.workspace_premium),
          _buildTakeawayItem('1-on-1 Mentor Access', Icons.support_agent),
          _buildTakeawayItem('Hands-on Project Portfolio', Icons.lightbulb_outline),

          const SizedBox(height: 24),
          const Text(
            'Requirements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No prior experience is necessary. A stable internet connection and basic computer literacy are the only requirements.',
            style: TextStyle(fontSize: 15, color: darkGreyText, height: 1.5),
          ),
        ],
      ),
    );
  }


  // --- NEW Content for the Reviews Tab ---
  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Add Review Section ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Your Review',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Rating Selector
                Row(
                  children: List.generate(5, (index) {
                    final ratingValue = index + 1.0;
                    return IconButton(
                      icon: Icon(
                        ratingValue <= _newReviewRating ? Icons.star : Icons.star_border,
                        color: accentYellow,
                      ),
                      iconSize: 32,
                      onPressed: () {
                        setState(() {
                          _newReviewRating = ratingValue;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),

                // Review Text Field
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Share your experience and thoughts on the course...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: darkGreyText.withAlpha((0.3 * 255).toInt())),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: primaryBlue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    fillColor: lightGreyBackground,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // --- Existing Reviews Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'User Reviews (${_reviews.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Review List
          ..._reviews.map((review) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ReviewCard(
              review: review,
              accentYellow: accentYellow,
              darkGreyText: darkGreyText,
            ),
          )),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final Course course = widget.course;
    final bool isInProgress = course.progress > 0.0 && course.progress < 1.0;
    final String buttonText = isInProgress ? 'Continue' : 'Start Learning';

    return DefaultTabController(
      length: 3, // Description, Curriculum, Reviews
      child: Scaffold(
        backgroundColor: cardBackground, // Use white/card background for content
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              // --- Flexible Header with Course Details ---
              SliverAppBar(
                // Increased expandedHeight from 330.0 to 350.0 to give more space
                expandedHeight: 350.0, 
                pinned: true, // Keep the TabBar visible when scrolling
                floating: false,
                backgroundColor: primaryBlue,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white), // Back button color
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  // Decreased bottom padding for title to give it more space from content below
                  titlePadding: const EdgeInsets.only(bottom: 110, left: 20),
                  title: Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Course Image
                      Image.network(
                        course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: primaryBlue.withAlpha((0.8 * 255).toInt()),
                              alignment: Alignment.center,
                              child: const Icon(Icons.school, color: Colors.white, size: 80),
                            );
                        },
                      ),
                      // Gradient Overlay for better text readability
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),

                      // --- Existing Overlay Content (Tag, Mentor, Rating) ---
                      Positioned(
                        left: 20,
                        right: 20,
                        // Increased bottom spacing to separate from the accessibility buttons
                        bottom: 150, 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: cardBackground, // White tag background on image
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
                            const SizedBox(height: 12), // Added space below tag
                            // Mentor and Rating
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  course.mentorName,
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                                const Spacer(),
                                _buildRatingRow(course.rating, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // --- NEW ACCESSIBILITY BUTTONS ---
                      Positioned(
                        left: 16,
                        right: 16,
                        // Adjusted to be further from the TabBar
                        bottom: 44, 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   'Choose Learning Mode:',
                            //   style: TextStyle(
                            //     color: Colors.white, 
                            //     fontSize: 14, 
                            //     fontWeight: FontWeight.w500
                            //   ),
                            // ),
                            const SizedBox(height: 3), // Increased space below label
                            Row(
                              children: [
                                // Video (Deaf/Hearing Impaired, Visual Learners)
                                _buildAccessibilityOptionButton(
                                  icon: Icons.videocam,
                                  label: 'Video',
                                  mode: 'Video',
                                  isAvailable: course.hasVideo,
                                ),
                                // Audio (Blind/Visually Impaired, Auditory Learners)
                                _buildAccessibilityOptionButton(
                                  icon: Icons.headset_mic,
                                  label: 'Audio',
                                  mode: 'Audio',
                                  isAvailable: course.hasAudio,
                                ),
                                // Text (Deaf/Blind with screen reader, Reading Learners)
                                _buildAccessibilityOptionButton(
                                  icon: Icons.description,
                                  label: 'Text',
                                  mode: 'Text',
                                  isAvailable: course.hasText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // --- Pinned Tab Bar ---
                bottom: const TabBar(
                  indicatorColor: primaryBlue,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color.fromARGB(255, 172, 172, 172),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Description'),
                    Tab(text: 'Curriculum'),
                    Tab(text: 'Reviews'),
                  ],
                ),
              ),
            ];
          },
          // --- Tab Content Area ---
          body: TabBarView(
            children: <Widget>[
              // 1. Description Tab
              _buildDescriptionTab(),

              // 2. Curriculum Tab
              _buildCurriculumList(),

              // 3. Reviews Tab (NEW IMPLEMENTATION)
              _buildReviewsTab(),
            ],
          ),
        ),

        // --- Persistent Bottom Action Bar ---
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => debugPrint('Action for course: $buttonText. Started in mode: $_selectedMode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

