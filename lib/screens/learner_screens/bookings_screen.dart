import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions (Consistent with previous screens) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color borderGrey = Color(0xFFE0E0E0);
const Color redAccent = Color(0xFFE53935); // For Cancel button
const Color successGreen = Color(0xFF4CAF50); // For Session status

// --- Data Models ---

enum SessionType { video, chat, inPerson }

enum SessionStatus { upcoming, past, cancelled }

class Booking {
  final String id;
  final String mentorName;
  final String skillTopic;
  final DateTime dateTime;
  final SessionType type;
  final SessionStatus status;
  bool feedbackProvided;
  String userNotes;

  Booking({
    required this.id,
    required this.mentorName,
    required this.skillTopic,
    required this.dateTime,
    required this.type,
    this.status = SessionStatus.upcoming,
    this.feedbackProvided = false,
    this.userNotes = '',
  });

  // Simple copyWith for state changes
  Booking copyWith({
    SessionStatus? status,
    bool? feedbackProvided,
    String? userNotes,
  }) {
    return Booking(
      id: id,
      mentorName: mentorName,
      skillTopic: skillTopic,
      dateTime: dateTime,
      type: type,
      status: status ?? this.status,
      feedbackProvided: feedbackProvided ?? this.feedbackProvided,
      userNotes: userNotes ?? this.userNotes,
    );
  }
}

// --- Sample Data ---

final List<Booking> mockBookings = [
  Booking(
    id: 'b001',
    mentorName: 'Dr. Evelyn Reed',
    skillTopic: 'Advanced Flutter State Management (Bloc)',
    dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
    type: SessionType.video,
    status: SessionStatus.upcoming,
  ),
  Booking(
    id: 'b002',
    mentorName: 'Dr. Evelyn Reed',
    skillTopic: 'Introduction to GraphQL APIs',
    dateTime: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
    type: SessionType.chat,
    status: SessionStatus.past,
    feedbackProvided: true,
    userNotes: 'Key takeaway: Use Fragments to avoid over-fetching in complex queries.',
  ),
  Booking(
    id: 'b003',
    mentorName: 'Mark Chen',
    skillTopic: 'Negotiating Salary and Compensation',
    dateTime: DateTime.now().add(const Duration(days: 5, hours: 10)),
    type: SessionType.inPerson,
    status: SessionStatus.upcoming,
  ),
  Booking(
    id: 'b004',
    mentorName: 'Mark Chen',
    skillTopic: 'Preparing for Technical Interviews',
    dateTime: DateTime.now().subtract(const Duration(days: 30)),
    type: SessionType.video,
    status: SessionStatus.past,
    feedbackProvided: false,
    userNotes: '',
  ),
  Booking(
    id: 'b005',
    mentorName: 'Laura Sanchez',
    skillTopic: 'Deep Learning Fundamentals with PyTorch',
    dateTime: DateTime.now().add(const Duration(hours: 4)),
    type: SessionType.video,
    status: SessionStatus.upcoming,
  ),
  Booking(
    id: 'b006',
    mentorName: 'Laura Sanchez',
    skillTopic: 'Canceled: Time Management for Developers',
    dateTime: DateTime.now().add(const Duration(days: 1)),
    type: SessionType.chat,
    status: SessionStatus.cancelled,
  ),
];

// --- Utility Widgets ---

Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Icon(icon, size: 18, color: darkGreyText),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: darkGreyText,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

// --- Card Widgets ---

class UpcomingSessionCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  const UpcomingSessionCard({
    super.key,
    required this.booking,
    required this.onReschedule,
    required this.onCancel,
  });

  String _formatDateTime(DateTime dt) {
    return DateFormat('MMM d, yyyy @ h:mm a').format(dt);
  }

  // Helper to determine icon for session type
  IconData _getIconForSessionType(SessionType type) {
    switch (type) {
      case SessionType.video:
        return Icons.videocam_rounded;
      case SessionType.chat:
        return Icons.chat_bubble_rounded;
      case SessionType.inPerson:
        return Icons.people_rounded;
    }
  }

  // Helper to determine the status text and color
  Widget _buildStatusChip() {
    Color color;
    String text;

    switch (booking.status) {
      case SessionStatus.upcoming:
        color = deepIndigo;
        text = 'Upcoming';
        break;
      case SessionStatus.cancelled:
        color = redAccent;
        text = 'Cancelled';
        break;
      default:
        color = successGreen;
        text = 'Completed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Topic and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.skillTopic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),

            // Mentor and Time Details
            _buildDetailRow(
              icon: Icons.person_outline,
              label: 'Mentor:',
              value: booking.mentorName,
            ),
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date & Time:',
              value: _formatDateTime(booking.dateTime),
            ),
            _buildDetailRow(
              icon: _getIconForSessionType(booking.type),
              label: 'Type:',
              value: booking.type.name.toUpperCase(),
            ),

            if (booking.status == SessionStatus.upcoming) ...[
              const SizedBox(height: 15),
              const Divider(color: borderGrey, height: 1),
              const SizedBox(height: 15),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReschedule,
                      icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                      label: const Text('Reschedule'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: deepIndigo,
                        side: const BorderSide(color: deepIndigo),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close, size: 18, color: Colors.white),
                      label: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redAccent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class PastSessionCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onRebook;
  final VoidCallback onFeedback;
  final Function(String) onSaveNotes;

  const PastSessionCard({
    super.key,
    required this.booking,
    required this.onRebook,
    required this.onFeedback,
    required this.onSaveNotes,
  });

  String _formatDateTime(DateTime dt) {
    return DateFormat('MMM d, yyyy @ h:mm a').format(dt);
  }

  // Helper to determine icon for session type
  IconData _getIconForSessionType(SessionType type) {
    switch (type) {
      case SessionType.video:
        return Icons.videocam_rounded;
      case SessionType.chat:
        return Icons.chat_bubble_rounded;
      case SessionType.inPerson:
        return Icons.people_rounded;
    }
  }

  // Helper to determine the status text and color
  Widget _buildStatusChip() {
    // Past sessions are assumed to be completed unless they were explicitly cancelled
    final isCancelled = booking.status == SessionStatus.cancelled;
    final color = isCancelled ? redAccent : successGreen;
    final text = isCancelled ? 'Cancelled' : 'Completed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Note: We use a temporary string variable for notes to pass back to the handler.
    // In a real app, this would likely be managed by a stateful parent or controller.
    String notes = booking.userNotes;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Topic and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.skillTopic, // <-- FIX APPLIED HERE
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),

            // Mentor and Time Details
            _buildDetailRow(
              icon: Icons.person_outline,
              label: 'Mentor:',
              value: booking.mentorName,
            ),
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date & Time:',
              value: _formatDateTime(booking.dateTime),
            ),
            _buildDetailRow(
              icon: _getIconForSessionType(booking.type),
              label: 'Type:',
              value: booking.type.name.toUpperCase(),
            ),

            if (booking.status == SessionStatus.past) ...[
              const SizedBox(height: 15),
              const Divider(color: borderGrey, height: 1),
              const SizedBox(height: 15),

              // User Notes Section
              const Text(
                'My Session Notes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: booking.userNotes,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add your key takeaways and notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: deepIndigo, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  notes = value;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => onSaveNotes(notes),
                  icon: const Icon(Icons.save_outlined, size: 20, color: Colors.white),
                  label: const Text('Save Notes', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepIndigo,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Divider(color: borderGrey, height: 1),
              const SizedBox(height: 15),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: booking.feedbackProvided ? null : onFeedback,
                      icon: Icon(booking.feedbackProvided ? Icons.check_circle_outline : Icons.star_border, size: 18),
                      label: Text(booking.feedbackProvided ? 'Feedback Submitted' : 'Give Feedback'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: booking.feedbackProvided ? successGreen : deepIndigo,
                        side: BorderSide(color: booking.feedbackProvided ? successGreen : deepIndigo),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRebook,
                      icon: const Icon(Icons.repeat, size: 18, color: Colors.white),
                      label: const Text('Rebook', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vibrantCyan,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 4. Main Screen (Stateful Widget)
// ----------------------------------------------------------------------------

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _bookings = mockBookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Mock Handlers for Actions ---

  void _handleReschedule(Booking booking) {
    logger.i('Reschedule pressed for: ${booking.skillTopic}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mock: Rescheduling ${booking.skillTopic}')),
    );
  }

  void _handleCancel(Booking booking) {
    logger.i('Cancel pressed for: ${booking.skillTopic}');
    setState(() {
      _bookings = _bookings.map((b) {
        if (b.id == booking.id) {
          return b.copyWith(status: SessionStatus.cancelled);
        }
        return b;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mock: Cancelled ${booking.skillTopic}')),
    );
  }

  void _handleRebook(Booking booking) {
    logger.i('Rebook pressed for: ${booking.skillTopic}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mock: Rebooking ${booking.skillTopic}')),
    );
  }

  void _handleFeedback(Booking booking) {
    logger.i('Give Feedback pressed for: ${booking.skillTopic}');
    setState(() {
      _bookings = _bookings.map((b) {
        if (b.id == booking.id) {
          return b.copyWith(feedbackProvided: true);
        }
        return b;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mock: Feedback submitted for ${booking.skillTopic}')),
    );
  }

  void _handleSaveNotes(String newNotes, Booking booking) {
    logger.i('Save Notes pressed for: ${booking.skillTopic}');
    setState(() {
      _bookings = _bookings.map((b) {
        if (b.id == booking.id) {
          return b.copyWith(userNotes: newNotes);
        }
        return b;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock: Notes saved locally!')),
    );
  }

  // --- Helper to build the list view for a tab ---
  Widget _buildBookingsList(bool isUpcoming) {
    final List<Booking> sessions = _bookings.where((b) {
      if (isUpcoming) {
        return b.status == SessionStatus.upcoming;
      } else {
        return b.status == SessionStatus.past || b.status == SessionStatus.cancelled;
      }
    }).toList();

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            isUpcoming
                ? 'You have no upcoming sessions booked.'
                : 'No past sessions to review.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: darkGreyText),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final booking = sessions[index];
        if (isUpcoming) {
          return UpcomingSessionCard(
            booking: booking,
            onReschedule: () => _handleReschedule(booking),
            onCancel: () => _handleCancel(booking),
          );
        } else {
          return PastSessionCard(
            booking: booking,
            onRebook: () => _handleRebook(booking),
            onFeedback: () => _handleFeedback(booking),
            onSaveNotes: (notes) => _handleSaveNotes(notes, booking),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('1-on-1 Bookings', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: TabBar(
          controller: _tabController,
          labelColor: deepIndigo,
          unselectedLabelColor: darkGreyText,
          indicatorColor: deepIndigo,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past/Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Tab
          _buildBookingsList(true),

          // Past/Cancelled Tab
          _buildBookingsList(false),
        ],
      ),
    );
  }
}
