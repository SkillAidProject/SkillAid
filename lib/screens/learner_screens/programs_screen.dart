import 'package:flutter/material.dart';
import 'learner_dashboard_screen.dart';
import 'program_details_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final List<String> mockCategories = ['All Programs', 'Technical', 'Soft Skills', 'Vocational', 'Leadership'];
  String _selectedCategory = 'All Programs';
  String _searchQuery = '';

  List<Course> get _filteredCourses {
    List<Course> courses = mockCourses;
    
    if (_selectedCategory != 'All Programs') {
      courses = courses.where((course) => course.tag == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      courses = courses.where((course) => 
        course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        course.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    courses.sort((a, b) => b.rating.compareTo(a.rating));
    return courses;
  }

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
    return Scaffold(
      backgroundColor: lightGreyBackground,
      // appBar: AppBar(
      //   backgroundColor: primaryBlue,
      //   elevation: 0,
      //   title: const Text(
      //     'All Programs',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: cardBackground),
      //   ),
      //   actions: const [
      //     Padding(
      //       padding: EdgeInsets.only(right: 16.0),
      //       child: Icon(Icons.notifications_none, color: cardBackground),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search programs or skills...',
                prefixIcon: const Icon(Icons.search, color: darkGreyText),
                filled: true,
                fillColor: cardBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryBlue, width: 2),
                ),
              ),
            ),
          ),

          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(category),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : darkGreyText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: isSelected ? primaryBlue : cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? primaryBlue : darkGreyText.withAlpha((0.3 * 255).toInt()),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                final course = _filteredCourses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DetailedCourseCard(
                    course: course,
                    onTap: () => _navigateToCourseDetail(course),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}