import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Bolder, Smart, and Eye-Catchy Color Palette (Consistent with recent screens) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50); // For Answered status
const Color warningOrange = Color(0xFFFF9800); // For Open/Unanswered status
const Color borderGrey = Color(0xFFE0E0E0);

// --- Data Models ---

class Answer {
  final String mentorName;
  final String content;
  final DateTime dateAnswered;

  Answer({required this.mentorName, required this.content, required this.dateAnswered});
}

class Question {
  final String id;
  final String title;
  final String body;
  final DateTime dateAsked;
  final String skillTopic;
  final Answer? topAnswer;

  Question({
    required this.id,
    required this.title,
    required this.body,
    required this.dateAsked,
    required this.skillTopic,
    this.topAnswer,
  });

  bool get isAnswered => topAnswer != null;
}

// --- Mock Data ---

final List<Question> mockQuestions = [
  Question(
    id: 'q1',
    title: 'How to implement a secure user authentication flow in React?',
    body: 'I am struggling with setting up JWT tokens properly. Should I use HTTP-only cookies or localStorage?',
    dateAsked: DateTime(2025, 11, 5, 10, 30),
    skillTopic: 'Web Development',
    topAnswer: Answer(
      mentorName: 'Dr. Alice Chen',
      content: 'For maximum security, you should always prefer **HTTP-only cookies** over localStorage for storing JWTs. This prevents XSS attacks from accessing the token. Also, ensure your backend uses a refresh token mechanism.',
      dateAnswered: DateTime(2025, 11, 6, 15, 10),
    ),
  ),
  Question(
    id: 'q2',
    title: 'Best practices for managing state in large Flutter apps?',
    body: 'I\'m moving from Provider to Riverpod, but feel overwhelmed by the structure. Any simple advice for large projects?',
    dateAsked: DateTime(2025, 11, 3, 14, 0),
    skillTopic: 'Mobile Development',
    topAnswer: null, // Open question
  ),
  Question(
    id: 'q3',
    title: 'Explain the difference between SQL and NoSQL databases.',
    body: 'I need to choose a database for a new project. When should I prioritize flexibility (NoSQL) versus strict schema (SQL)?',
    dateAsked: DateTime(2025, 10, 28, 8, 45),
    skillTopic: 'Data Science',
    topAnswer: Answer(
      mentorName: 'Mentor Bob Smith',
      content: 'SQL databases are best for applications requiring complex transactions (ACID properties) like banking. NoSQL (like MongoDB) shines with flexible, schema-less data, ideal for content management systems or high-volume data.',
      dateAnswered: DateTime(2025, 10, 30, 11, 22),
    ),
  ),
  Question(
    id: 'q4',
    title: 'What are the core concepts of leadership ethics?',
    body: 'Looking for a brief overview on ethical frameworks relevant to executive leadership.',
    dateAsked: DateTime(2025, 10, 15, 19, 10),
    skillTopic: 'Soft Skills',
    topAnswer: Answer(
      mentorName: 'Ms. Clara Johnson',
      content: 'Key concepts include **Deontology** (duty-based), **Utilitarianism** (outcome-based), and **Virtue Ethics** (character-based). An ethical leader balances all three.',
      dateAnswered: DateTime(2025, 10, 16, 9, 30),
    ),
  ),
];

// --- Question Screen Implementation ---

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  String _searchText = '';
  String? _selectedTopic;
  String _sortOption = 'date_newest'; // Options: date_newest, date_oldest, unanswered
  String? _expandedQuestionId; // Tracks which question tile is expanded

  final List<String> topics = ['All', 'Web Development', 'Mobile Development', 'Data Science', 'Soft Skills'];
  final DateFormat formatter = DateFormat('MMM dd, yyyy');

  List<Question> get _filteredAndSortedQuestions {
    List<Question> filtered = mockQuestions.where((q) {
      final matchesTopic = _selectedTopic == null || q.skillTopic == _selectedTopic;
      final matchesSearch = _searchText.isEmpty ||
          q.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          q.body.toLowerCase().contains(_searchText.toLowerCase());
      return matchesTopic && matchesSearch;
    }).toList();

    // Sorting logic
    if (_sortOption == 'unanswered') {
      filtered.sort((a, b) {
        // Unanswered questions come first
        if (!a.isAnswered && b.isAnswered) return -1;
        if (a.isAnswered && !b.isAnswered) return 1;
        return b.dateAsked.compareTo(a.dateAsked); // Use newest date as secondary sort
      });
    } else if (_sortOption == 'date_oldest') {
      filtered.sort((a, b) => a.dateAsked.compareTo(b.dateAsked));
    } else {
      // date_newest (default)
      filtered.sort((a, b) => b.dateAsked.compareTo(a.dateAsked));
    }

    return filtered;
  }

  // Helper to build the topic filter chips
  Widget _buildTopicChip(String topic) {
    final isSelected = _selectedTopic == topic || (topic == 'All' && _selectedTopic == null);
    final displayTopic = topic == 'All' ? 'All Topics' : topic;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(displayTopic),
        selected: isSelected,
        backgroundColor: lightBackground,
        selectedColor: vibrantCyan.withAlpha((0.1 * 255).toInt()),
        checkmarkColor: vibrantCyan,
        labelStyle: TextStyle(
          color: isSelected ? vibrantCyan : darkGreyText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        side: BorderSide(
          color: isSelected ? vibrantCyan : borderGrey,
          width: 1,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedTopic = topic == 'All' ? null : topic;
          });
        },
      ),
    );
  }

  // Helper to build the sort dropdown
  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _sortOption,
        icon: const Icon(Icons.sort, color: darkGreyText),
        style: const TextStyle(color: darkGreyText, fontSize: 14),
        items: const [
          DropdownMenuItem(value: 'date_newest', child: Text('Newest First')),
          DropdownMenuItem(value: 'date_oldest', child: Text('Oldest First')),
          DropdownMenuItem(value: 'unanswered', child: Text('Unanswered First')),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _sortOption = newValue;
            });
          }
        },
      ),
    );
  }

  // Helper to build the question list tile
  Widget _buildQuestionTile(Question question) {
    final isExpanded = _expandedQuestionId == question.id;
    final statusColor = question.isAnswered ? successGreen : warningOrange;
    final statusText = question.isAnswered ? 'Answered' : 'Open';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        color: cardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isExpanded ? vibrantCyan : borderGrey, width: isExpanded ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              if (_expandedQuestionId == question.id) {
                _expandedQuestionId = null;
              } else {
                _expandedQuestionId = question.id;
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Question Summary Header ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skill/Topic Tag
                        _buildTag(question.skillTopic),
                        // Status Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha((0.15 * 255).toInt()),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Question Title
                    Text(
                      question.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Date Asked
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: darkGreyText),
                        const SizedBox(width: 4),
                        Text(
                          'Asked: ${formatter.format(question.dateAsked)}',
                          style: const TextStyle(fontSize: 13, color: darkGreyText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Expanded Content (Mentor Answer) ---
              if (isExpanded)
                question.isAnswered
                    ? _buildAnswerPreview(question.topAnswer!)
                    : _buildOpenStatus(),

              // --- Expansion Indicator ---
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      isExpanded ? 'Tap to collapse' : 'Tap to view ${question.isAnswered ? 'answer' : 'details'}',
                      style: TextStyle(color: darkGreyText.withAlpha((0.7 * 255).toInt()), fontSize: 12),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: darkGreyText.withAlpha((0.7 * 255).toInt()),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String topic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: deepIndigo.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        topic,
        style: const TextStyle(
          color: deepIndigo,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOpenStatus() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: warningOrange.withAlpha((0.05 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: warningOrange.withAlpha((0.2 * 255).toInt()), width: 1),
        ),
        child: const Row(
          children: [
            Icon(Icons.pending_actions, color: warningOrange, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'This question is still open. A mentor will respond soon!',
                style: TextStyle(color: darkGreyText, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerPreview(Answer answer) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reply_all, color: successGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'Mentor Response by ${answer.mentorName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: successGreen,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(height: 12, color: borderGrey),
          Text(
            answer.content,
            style: const TextStyle(color: darkGreyText, fontSize: 14),
            maxLines: 4, // Show a maximum of 4 lines of the answer
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Answered: ${formatter.format(answer.dateAnswered)}',
            style: TextStyle(color: darkGreyText.withAlpha((0.7 * 255).toInt()), fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredQuestions = _filteredAndSortedQuestions;

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text(
          'My Questions',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: lightBackground,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search questions by title or keyword...',
                prefixIcon: const Icon(Icons.search, color: deepIndigo),
                filled: true,
                fillColor: cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          // --- Filters & Sort ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: topics.map(_buildTopicChip).toList(),
                    ),
                  ),
                ),
                _buildSortDropdown(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: borderGrey),

          // --- Question Feed List ---
          Expanded(
            child: filteredQuestions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 60, color: darkGreyText.withAlpha((0.4 * 255).toInt())),
                        const SizedBox(height: 10),
                        const Text(
                          'No questions found.',
                          style: TextStyle(fontSize: 16, color: darkGreyText),
                        ),
                        const Text(
                          'Try adjusting your filters or search terms.',
                          style: TextStyle(fontSize: 14, color: darkGreyText),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredQuestions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionTile(filteredQuestions[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}