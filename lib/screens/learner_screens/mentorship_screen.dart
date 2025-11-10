import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions ---
const Color primaryBlue = Color(0xFF1E88E5); 
const Color lightGreyBackground = Color(0xFFF5F5F5); 
const Color darkGreyText = Color(0xFF5A5A5A); 
const Color borderGrey = Color(0xFFE0E0E0); 
const Color accentYellow = Color(0xFFFDD835); // For ratings
const Color accentGreen = Color(0xFF4CAF50); // For success/stats (Lessons) - Used for Booking
const Color accentOrange = Color(0xFFFF9800); // For Public Questions Stat and Resources
const Color redAccent = Color(0xFFE53935); // For clear button

// --- Data Models ---

class Review {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({required this.userName, required this.rating, required this.comment, required this.date});
}

// NEW: Model for public questions and answers
class Question {
  final String questionerName;
  final String questionText;
  final String? answerText;
  final DateTime date;

  Question({
    required this.questionerName,
    required this.questionText,
    this.answerText,
    required this.date,
  });
}

class Lesson {
  final String title;
  final String duration;
  final String type; // Video, Audio
  Lesson({required this.title, required this.duration, required this.type});
}

class Resource {
  final String title;
  final String type; // PDF, Video, Cheatsheet
  final IconData icon;
  Resource({required this.title, required this.type, required this.icon});
}

class Mentor {
  final String id;
  final String name;
  final String title;
  final String expertise;
  final double rating;
  final int reviewsCount; 
  final String bio;
  final String imageUrl;
  final List<String> skills;
  final String experienceLevel; 
  final String availability;    
  final String language;        
  final String location;        
  final int menteesCount;
  final int publicQuestionsAsked; 
  final List<Question> publicQandA; // NEW: List of Q&A
  final List<Review> reviews; 
  final List<Lesson> availableLessons; 
  final List<Resource> downloadableResources; 

  Mentor({
    required this.id,
    required this.name,
    required this.title,
    required this.expertise,
    required this.rating,
    required this.reviewsCount,
    required this.bio,
    required this.imageUrl,
    required this.skills,
    required this.experienceLevel,
    required this.availability,
    required this.language,
    required this.location,
    required this.menteesCount,
    required this.publicQuestionsAsked, 
    required this.publicQandA, // NEW
    required this.reviews,
    required this.availableLessons,
    required this.downloadableResources,
  });
}

// --- Filter Model (Unchanged) ---
class MentorFilters {
  String searchTerm;
  String? experienceLevel;
  double? minRating;
  String? availability;
  String? language;
  String? location;

  MentorFilters({
    this.searchTerm = '',
    this.experienceLevel,
    this.minRating,
    this.availability,
    this.language,
    this.location,
  });

  bool get hasActiveFilters =>
      experienceLevel != null ||
      minRating != null ||
      availability != null ||
      language != null ||
      location != null;
  
  MentorFilters copyWith({
    String? searchTerm,
    String? experienceLevel,
    double? minRating,
    String? availability,
    String? language,
    String? location,
  }) {
    return MentorFilters(
      searchTerm: searchTerm ?? this.searchTerm,
      experienceLevel: experienceLevel,
      minRating: minRating,
      availability: availability,
      language: language,
      location: location,
    );
  }
}


// --- Mock Data (Updated with Questions) ---

final List<Review> mockReviews = [
  Review(
    userName: 'Alex R.',
    rating: 5.0,
    comment: 'An amazing mentor! Very insightful and helped me land my first job in software development. Highly recommend. They are very responsive and clear in their explanations.',
    date: DateTime(2023, 10, 15),
  ),
  Review(
    userName: 'Sara L.',
    rating: 4.5,
    comment: 'Great guidance on project architecture. Sometimes a bit slow to respond, but the quality of advice is superb.',
    date: DateTime(2023, 11, 22),
  ),
  Review(
    userName: 'Ben K.',
    rating: 5.0,
    comment: 'The best investment I have made in my career. His expertise in AI is unparalleled.',
    date: DateTime(2024, 1, 10),
  ),
  Review(
    userName: 'Chloe V.',
    rating: 4.0,
    comment: 'Solid advice, especially on soft skills. I wish there were more scheduled 1-on-1 sessions.',
    date: DateTime(2024, 2, 5),
  ),
  Review(
    userName: 'David M.',
    rating: 5.0,
    comment: 'Truly passionate about teaching. He simplified complex topics with ease.',
    date: DateTime(2024, 3, 1),
  ),
];

// NEW: Mock Q&A data
final List<Question> mockQuestions = [
  Question(
    questionerName: 'Sarah J.',
    questionText: 'What is the best approach for hyperparameter tuning in deep learning models?',
    answerText: 'For initial experiments, Bayesian Optimization works great, but for production, consider tools like Ray Tune or Weights & Biases for efficient parallelized searches.',
    date: DateTime(2024, 4, 1),
  ),
  Question(
    questionerName: 'Mark D.',
    questionText: 'How do you handle class imbalance in a classification task?',
    answerText: 'Common techniques include using Synthetic Minority Over-sampling Technique (SMOTE), adjusting class weights, or resampling the dataset.',
    date: DateTime(2024, 4, 10),
  ),
  Question(
    questionerName: 'Emily T.',
    questionText: 'Is Flutter a good choice for large enterprise applications?',
    answerText: 'Yes, absolutely. Its single codebase, high performance, and growing ecosystem make it suitable, especially when targeting multiple platforms.',
    date: DateTime(2024, 4, 20),
  ),
];


final List<Lesson> mockLessons = [
  Lesson(title: 'Introduction to Neural Networks', duration: '15:30', type: 'Video'),
  Lesson(title: 'Advanced Python Debugging', duration: '12:05', type: 'Video'),
  Lesson(title: 'Data Preprocessing Techniques', duration: '08:45', type: 'Audio'),
  Lesson(title: 'Deployment with Docker', duration: '20:10', type: 'Video'),
];

final List<Resource> mockResources = [
  Resource(title: 'Python Cheat Sheet', type: 'PDF', icon: Icons.description),
  Resource(title: 'Interview Q&A Guide', type: 'Cheatsheet', icon: Icons.article),
  Resource(title: 'Deployment Checklist', type: 'Checklist', icon: Icons.checklist),
];

final List<Mentor> mockMentors = [
  Mentor(
    id: 'm1',
    name: 'Dr. Evelyn Reed',
    title: 'Senior Data Scientist',
    expertise: 'Machine Learning, Python, AI',
    rating: 4.8,
    reviewsCount: mockReviews.length,
    bio: 'Dr. Reed is a leading expert in scalable machine learning models with 10+ years of experience in tech.',
    imageUrl: 'https://placehold.co/100x100/1E88E5/FFFFFF?text=ER',
    skills: ['Python', 'SQL', 'TensorFlow', 'Data Modeling', 'Cloud Computing'],
    experienceLevel: 'Senior',
    availability: 'Part-time',
    language: 'English',
    location: 'Remote',
    menteesCount: 45,
    publicQuestionsAsked: mockQuestions.length + 147, // Total Qs: 150
    publicQandA: mockQuestions, // ADDED
    reviews: mockReviews,
    availableLessons: mockLessons,
    downloadableResources: mockResources,
  ),
  Mentor(
    id: 'm2',
    name: 'John Doe',
    title: 'Full Stack Developer',
    expertise: 'React, Node.js, JavaScript',
    rating: 4.5,
    reviewsCount: 15,
    bio: 'John specializes in building and scaling modern web applications using the MERN stack.',
    imageUrl: 'https://placehold.co/100x100/FDD835/000000?text=JD',
    skills: ['React', 'Node.js', 'MongoDB', 'AWS', 'JavaScript'],
    experienceLevel: 'Intermediate',
    availability: 'Full-time',
    language: 'English, Spanish',
    location: 'New York',
    menteesCount: 22,
    publicQuestionsAsked: 85, 
    publicQandA: [], // Empty Q&A list for this mentor
    reviews: [
      Review(userName: 'Lisa M.', rating: 4.5, comment: 'Very helpful with my React project.', date: DateTime(2024, 4, 1)),
      Review(userName: 'Tom S.', rating: 4.8, comment: 'Excellent Node.js advice.', date: DateTime(2024, 4, 15)),
    ],
    availableLessons: [],
    downloadableResources: [],
  ),
  Mentor(
    id: 'm3', 
    name: 'Maria Sanchez',
    title: 'Lead Product Manager',
    expertise: 'Agile, SaaS, Product Strategy',
    rating: 4.9,
    reviewsCount: 30,
    bio: 'Maria leads product development for major SaaS platforms.',
    imageUrl: 'https://placehold.co/100x100/4CAF50/FFFFFF?text=MS',
    skills: ['Product Strategy', 'JIRA', 'UX/UI', 'Go-to-Market'],
    experienceLevel: 'Lead',
    availability: 'Weekends',
    language: 'Spanish',
    location: 'London',
    menteesCount: 50,
    publicQuestionsAsked: 210, 
    publicQandA: mockQuestions,
    reviews: [],
    availableLessons: [],
    downloadableResources: [],
  ),
];

// --- Filter Options Definitions (Unchanged) ---
const List<String> experienceLevels = ['Junior', 'Intermediate', 'Senior', 'Lead'];
const Map<String, double> ratingOptions = {
  '4.5+': 4.5,
  '4.0+': 4.0,
  '3.0+': 3.0,
};
const List<String> availabilityOptions = ['Full-time', 'Part-time', 'Weekends'];
const List<String> languageOptions = ['English', 'Spanish', 'Japanese', 'Mandarin'];
const List<String> locationOptions = ['Remote', 'New York', 'London', 'Berlin'];

// -----------------------------------------------------------------------------
// 1. Helper Widgets 
// -----------------------------------------------------------------------------

/// Builds the star rating display for a review or mentor.
Widget _buildStarRating(double rating) {
  final int fullStars = rating.floor();
  final bool hasHalfStar = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
  final int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (int i = 0; i < fullStars; i++)
        const Icon(Icons.star, color: accentYellow, size: 16),
      if (hasHalfStar)
        const Icon(Icons.star_half, color: accentYellow, size: 16),
      for (int i = 0; i < emptyStars; i++)
        Icon(Icons.star_border, color: Colors.grey[400], size: 16),
      const SizedBox(width: 8),
      Text(
        rating.toStringAsFixed(1),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ],
  );
}

String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
}

/// A simple tag widget for displaying skills.
Widget _buildSkillTag(String skill) {
  return Container(
    margin: const EdgeInsets.only(right: 8, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: primaryBlue.withAlpha((0.1 * 255).toInt()),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: primaryBlue.withAlpha((0.3 * 255).toInt())),
    ),
    child: Text(
      skill,
      style: const TextStyle(
        color: primaryBlue,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

/// A tile for displaying a single mentor review.
class ReviewTile extends StatelessWidget {
  final Review review;
  final int maxLines; 

  const ReviewTile({super.key, required this.review, this.maxLines = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderGrey, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
              ),
              Text(
                _formatDate(review.date),
                style: const TextStyle(fontSize: 12, color: darkGreyText),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildStarRating(review.rating),
          const SizedBox(height: 8),
          Text(
            review.comment,
            maxLines: maxLines, 
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

/// A card to display a mentor's single statistic.
class MentorStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap; 

  const MentorStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector( 
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              // If clickable, use primary blue border; otherwise, standard grey
              color: onTap != null ? primaryBlue.withAlpha((0.5 * 255).toInt()) : borderGrey, 
              width: 1
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: darkGreyText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A card for lessons and downloadable resources
Widget _buildContentResourceCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: borderGrey, width: 1),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: darkGreyText),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: darkGreyText),
          ],
        ),
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// 2. All Reviews Screen (UPDATED to allow submission)
// -----------------------------------------------------------------------------

class AllReviewsScreen extends StatefulWidget {
  final String mentorName;
  final List<Review> initialReviews;

  const AllReviewsScreen({
    super.key,
    required this.mentorName,
    required this.initialReviews,
  });

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  // Use a local mutable list to simulate adding new reviews
  late List<Review> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List.from(widget.initialReviews);
  }

  void _addReview(Review newReview) {
    setState(() {
      // Prepend new review to show it immediately at the top
      _reviews.insert(0, newReview);
    });
    // In a real app, this is where you would call an API to save the review.
    logger.i('New review submitted by ${newReview.userName}');
  }

  void _showSubmitReviewModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SubmitReviewModal(
            mentorName: widget.mentorName,
            onSubmit: (rating, comment) {
              final newReview = Review(
                userName: 'Current User', // Mocked current user name
                rating: rating,
                comment: comment,
                date: DateTime.now(),
              );
              _addReview(newReview);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.mentorName}\'s Reviews (${_reviews.length})'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: _reviews.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No reviews available. Be the first to share your experience!',
                  style: TextStyle(fontSize: 16, color: darkGreyText),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                return ReviewTile(review: _reviews[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSubmitReviewModal,
        label: const Text('Submit Review'),
        icon: const Icon(Icons.star),
        backgroundColor: accentYellow,
        foregroundColor: Colors.black87,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. Submit Review Modal (NEW)
// -----------------------------------------------------------------------------

class SubmitReviewModal extends StatefulWidget {
  final String mentorName;
  final Function(double rating, String comment) onSubmit;

  const SubmitReviewModal({
    super.key,
    required this.mentorName,
    required this.onSubmit,
  });

  @override
  State<SubmitReviewModal> createState() => _SubmitReviewModalState();
}

class _SubmitReviewModalState extends State<SubmitReviewModal> {
  double _currentRating = 5.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Review ${widget.mentorName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text('Your Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _currentRating.round() ? Icons.star : Icons.star_border,
                    color: accentYellow,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentRating = (index + 1).toDouble();
                    });
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Your Comment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your experience...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_commentController.text.trim().isNotEmpty) {
                widget.onSubmit(_currentRating, _commentController.text.trim());
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a comment.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Submit', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. Public Questions Screen (NEW)
// -----------------------------------------------------------------------------

class PublicQuestionsScreen extends StatelessWidget {
  final String mentorName;
  final List<Question> questions;

  const PublicQuestionsScreen({
    super.key,
    required this.mentorName,
    required this.questions,
  });

  Widget _buildQuestionTile(Question q) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Row(
              children: [
                const Icon(Icons.question_mark_rounded, color: primaryBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    q.questionText,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0, top: 2),
              child: Text(
                'Asked by ${q.questionerName} on ${_formatDate(q.date)}',
                style: const TextStyle(fontSize: 12, color: darkGreyText),
              ),
            ),
            const SizedBox(height: 15),

            // Answer
            if (q.answerText != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.reply, color: accentGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mentor\'s Answer:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: accentGreen),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.answerText!,
                          style: const TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Text(
                  'Awaiting mentor response...',
                  style: TextStyle(fontSize: 13, color: redAccent.withAlpha((0.7 * 255).toInt())),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyBackground,
      appBar: AppBar(
        title: Text('$mentorName\'s Public Q&A'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: questions.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No public questions have been answered yet.',
                  style: TextStyle(fontSize: 16, color: darkGreyText),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionTile(questions[index]);
              },
            ),
    );
  }
}


// -----------------------------------------------------------------------------
// 5. Mentor Detail Screen (UPDATED Stats and Actions)
// -----------------------------------------------------------------------------

class MentorDetailScreen extends StatelessWidget {
  final Mentor mentor;

  const MentorDetailScreen({super.key, required this.mentor});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildMentorStats(BuildContext context, Mentor mentor) {
    final bool isReviewsClickable = mentor.reviews.isNotEmpty;
    final bool isQuestionsClickable = mentor.publicQuestionsAsked > 0;

    final VoidCallback? onReviewsTap = isReviewsClickable
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllReviewsScreen(
                  mentorName: mentor.name,
                  initialReviews: mentor.reviews,
                ),
              ),
            );
          }
        : null; 
    
    // NEW: OnTap for Public Questions
    final VoidCallback? onQuestionsTap = isQuestionsClickable
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PublicQuestionsScreen(
                  mentorName: mentor.name,
                  questions: mentor.publicQandA,
                ),
              ),
            );
          }
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // Stat 1: Public Questions Asked (NOW CLICKABLE)
          MentorStatCard(
            icon: Icons.forum_outlined,
            value: mentor.publicQuestionsAsked.toString(),
            label: 'Public Questions',
            color: accentOrange, 
            onTap: onQuestionsTap, // NEW: Make it navigable
          ),
          const SizedBox(width: 10),
          // Stat 2: Total Reviews (NOW CLICKABLE)
          MentorStatCard(
            icon: Icons.reviews,
            value: mentor.reviewsCount.toString(),
            label: 'Total Reviews Submitted',
            color: primaryBlue,
            onTap: onReviewsTap, // Pass the navigation function
          ),
          const SizedBox(width: 10),
          // Stat 3: Mentees Count
          MentorStatCard(
            icon: Icons.person_pin,
            value: mentor.menteesCount.toString(),
            label: 'Mentees Helped',
            color: accentGreen,
          ),
        ],
      ),
    );
  }

  // Action Buttons (Correctly uses Book 1-on-1 Session)
  Widget _buildActionButtons(BuildContext context, Mentor mentor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          // Private Message Button (Primary Action)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                logger.i('Attempting to send private message to ${mentor.name}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Starting private chat with ${mentor.name} (Mock)')),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Private Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Book 1-on-1 Session Button (Secondary Action)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                logger.i('Attempting to book 1-on-1 session with ${mentor.name}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening booking screen for ${mentor.name} (Mock)')),
                );
              },
              icon: const Icon(Icons.calendar_month, color: accentGreen), 
              label: const Text('Book 1-on-1 Session'), 
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: accentGreen, width: 2), 
                foregroundColor: accentGreen, 
                backgroundColor: accentGreen.withAlpha((0.05 * 255).toInt()), 
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Review> reviewsToShow = mentor.reviews.take(3).toList();

    final VoidCallback? onReviewsTap = mentor.reviews.isNotEmpty
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllReviewsScreen(
                  mentorName: mentor.name,
                  initialReviews: mentor.reviews,
                ),
              ),
            );
          }
        : null; 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mentor Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      mentor.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 80,
                            height: 80,
                            color: borderGrey,
                            child: const Icon(Icons.person, color: darkGreyText),
                          ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentor.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mentor.title,
                          style: const TextStyle(fontSize: 16, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        // Display the rating here 
                        _buildStarRating(mentor.rating), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: borderGrey),

            // Mentor Stats (Includes clickable Public Questions Asked)
            const SizedBox(height: 20),
            _buildMentorStats(context, mentor), 
            const SizedBox(height: 20),
            
            // ACTION BUTTONS SECTION (Book 1-on-1 Session)
            _buildActionButtons(context, mentor),
            
            const Divider(height: 1, color: borderGrey),

            // Bio Section
            _buildSectionTitle('About Me'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                mentor.bio,
                style: const TextStyle(fontSize: 15, color: darkGreyText, height: 1.4),
              ),
            ),
            const SizedBox(height: 10),

            // Skills Section
            _buildSectionTitle('Key Skills'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Wrap(
                children: mentor.skills.map((skill) => _buildSkillTag(skill)).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Lessons Section
            if (mentor.availableLessons.isNotEmpty) ...[
              _buildSectionTitle('Available Lessons'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: mentor.availableLessons.map((lesson) => _buildContentResourceCard(
                    title: lesson.title,
                    subtitle: 'Type: ${lesson.type} - Duration: ${lesson.duration}',
                    icon: lesson.type == 'Video' ? Icons.play_circle_fill : Icons.mic,
                    color: accentGreen,
                    onTap: () {
                      logger.i('Starting lesson: ${lesson.title}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Starting lesson: ${lesson.title} (Mock)')),
                      );
                    },
                  )).toList(),
                ),
              ),
            ],

            // Downloadable Resources Section
            if (mentor.downloadableResources.isNotEmpty) ...[
              _buildSectionTitle('Downloadable Resources'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: mentor.downloadableResources.map((resource) => _buildContentResourceCard(
                    title: resource.title,
                    subtitle: 'File Type: ${resource.type}',
                    icon: resource.icon,
                    color: accentOrange,
                    onTap: () {
                      logger.i('Downloading resource: ${resource.title}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading file: ${resource.title} (Mock)')),
                      );
                    },
                  )).toList(),
                ),
              ),
            ],

            // Testimonials/Reviews 
            _buildSectionTitle('Testimonials & Reviews'),
            if (mentor.reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Center(
                  child: Text(
                    'No reviews yet. Be the first to share your experience!',
                    style: TextStyle(color: darkGreyText),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display limited reviews on detail screen
                    ...reviewsToShow.map((review) => ReviewTile(review: review, maxLines: 2)),
                    if (mentor.reviews.length > reviewsToShow.length)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: TextButton(
                          onPressed: onReviewsTap,
                          child: Text(
                            'View All ${mentor.reviews.length} Reviews',
                            style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. Mentor Filter Modal (Unchanged)
// -----------------------------------------------------------------------------

class FilterModal extends StatefulWidget {
  final MentorFilters initialFilters;
  final Function(MentorFilters) onApply;

  const FilterModal({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  // Local state to manage filter selections within the modal
  late String? _experienceLevel;
  late double? _minRating;
  late String? _availability;
  late String? _language;
  late String? _location;

  @override
  void initState() {
    super.initState();
    _experienceLevel = widget.initialFilters.experienceLevel;
    _minRating = widget.initialFilters.minRating;
    _availability = widget.initialFilters.availability;
    _language = widget.initialFilters.language;
    _location = widget.initialFilters.location;
  }

  // Utility widget for rendering filter chips
  Widget _buildFilterChip({
    required String label,
    required String? currentValue,
    required Function(String) onSelected,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            // "Any" / Clear option
            _buildChoiceChip(
              label: 'Any',
              isSelected: currentValue == null || currentValue == 'Any',
              onSelected: (_) => onSelected('Any'),
            ),
            // Actual options
            ...options.map((option) => _buildChoiceChip(
                  label: option,
                  isSelected: currentValue == option,
                  onSelected: (_) => onSelected(option),
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: primaryBlue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : darkGreyText,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: lightGreyBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? primaryBlue : borderGrey,
          width: 1.2,
        ),
      ),
      onSelected: onSelected,
    );
  }

  void _applyFilters() {
    // Convert 'Any' selection back to null for the model
    final newFilters = MentorFilters(
      searchTerm: widget.initialFilters.searchTerm,
      experienceLevel: _experienceLevel == 'Any' ? null : _experienceLevel,
      minRating: _minRating, 
      availability: _availability == 'Any' ? null : _availability,
      language: _language == 'Any' ? null : _language,
      location: _location == 'Any' ? null : _location,
    );
    widget.onApply(newFilters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _experienceLevel = null;
      _minRating = null;
      _availability = null;
      _language = null;
      _location = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: borderGrey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Mentors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all, color: redAccent),
                label: const Text('Clear All', style: TextStyle(color: redAccent)),
              ),
            ],
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Experience Level Filter ---
                  _buildFilterChip(
                    label: 'Experience Level',
                    currentValue: _experienceLevel,
                    onSelected: (val) => setState(() => _experienceLevel = val),
                    options: experienceLevels,
                  ),

                  // --- Minimum Rating Filter ---
                  _buildFilterChip(
                    label: 'Minimum Rating',
                    currentValue: ratingOptions.entries.firstWhere(
                      (e) => e.value == _minRating,
                      orElse: () => const MapEntry('Any', 0.0),
                    ).key,
                    onSelected: (val) {
                      setState(() {
                        _minRating = (val == 'Any') ? null : ratingOptions[val];
                      });
                    },
                    options: ratingOptions.keys.toList(),
                  ),

                  // --- Availability Filter ---
                  _buildFilterChip(
                    label: 'Availability',
                    currentValue: _availability,
                    onSelected: (val) => setState(() => _availability = val),
                    options: availabilityOptions,
                  ),

                  // --- Language Filter ---
                  _buildFilterChip(
                    label: 'Language',
                    currentValue: _language,
                    onSelected: (val) => setState(() => _language = val),
                    options: languageOptions,
                  ),

                  // --- Location Filter ---
                  _buildFilterChip(
                    label: 'Location',
                    currentValue: _location,
                    onSelected: (val) => setState(() => _location = val),
                    options: locationOptions,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Apply Button
          ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Apply Filters', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 7. Mentors Screen (Unchanged)
// -----------------------------------------------------------------------------

class MentorsScreen extends StatefulWidget {
  const MentorsScreen({super.key});

  @override
  State<MentorsScreen> createState() => _MentorsScreenState();
}

class _MentorsScreenState extends State<MentorsScreen> {
  MentorFilters _filters = MentorFilters();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filters.searchTerm = _searchController.text.toLowerCase().trim();
    });
  }

  List<Mentor> get _filteredMentors {
    final term = _filters.searchTerm;
    return mockMentors.where((mentor) {
      bool matchesSearch = true;
      if (term.isNotEmpty) {
        // Search matches name, title, expertise, or skills
        matchesSearch = mentor.name.toLowerCase().contains(term) ||
            mentor.title.toLowerCase().contains(term) ||
            mentor.expertise.toLowerCase().contains(term) ||
            mentor.skills.any((skill) => skill.toLowerCase().contains(term));
      }

      // Filter 1: Experience Level
      bool matchesExperience = _filters.experienceLevel == null ||
          mentor.experienceLevel == _filters.experienceLevel;

      // Filter 2: Minimum Rating
      bool matchesRating = _filters.minRating == null ||
          mentor.rating >= _filters.minRating!;

      // Filter 3: Availability
      bool matchesAvailability = _filters.availability == null ||
          mentor.availability == _filters.availability;

      // Filter 4: Language (mentor language list contains the selected language)
      bool matchesLanguage = _filters.language == null ||
          mentor.language.contains(_filters.language!);

      // Filter 5: Location
      bool matchesLocation = _filters.location == null ||
          mentor.location == _filters.location;

      return matchesSearch &&
          matchesExperience &&
          matchesRating &&
          matchesAvailability &&
          matchesLanguage &&
          matchesLocation;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FilterModal(
            initialFilters: _filters,
            onApply: (newFilters) {
              setState(() {
                _filters = newFilters;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildMentorCard(BuildContext context, Mentor mentor) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MentorDetailScreen(mentor: mentor),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mentor Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  mentor.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        width: 60,
                        height: 60,
                        color: borderGrey,
                        child: const Icon(Icons.person, color: darkGreyText),
                      ),
                ),
              ),
              const SizedBox(width: 15),
              // Mentor Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mentor.title,
                      style: const TextStyle(fontSize: 14, color: primaryBlue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mentor.expertise,
                      style: const TextStyle(fontSize: 13, color: darkGreyText),
                    ),
                    const SizedBox(height: 8),
                    // Rating and Reviews Count
                    Row(
                      children: [
                        _buildStarRating(mentor.rating),
                        const SizedBox(width: 10),
                        Text(
                          '(${mentor.reviewsCount} reviews)',
                          style: const TextStyle(fontSize: 12, color: darkGreyText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: borderGrey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mentors = _filteredMentors;
    final bool isFiltered = _filters.hasActiveFilters || _filters.searchTerm.isNotEmpty;

    return Scaffold(
      backgroundColor: lightGreyBackground,
      // appBar: AppBar(
      //   // title: const Text('Find a Mentor'),
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black87,
      //   elevation: 0,
      //   centerTitle: false,
      //   bottom: 
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by skill, name, or expertise',
                          prefixIcon: const Icon(Icons.search, color: darkGreyText),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: darkGreyText),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: isFiltered ? accentYellow : Colors.white,
                        ),
                        onPressed: _showFilterModal,
                        tooltip: 'Filter Mentors',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isFiltered)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Showing ${mentors.length} mentors (filtered)',
                  style: const TextStyle(fontSize: 14, color: darkGreyText, fontWeight: FontWeight.w600),
                ),
              ),
            
            if (mentors.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'No mentors match your search and filter criteria.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: darkGreyText),
                  ),
                ),
              )
            else
              ...mentors.map((mentor) => _buildMentorCard(context, mentor)),
          ],
        ),
      ),
    );
  }
}