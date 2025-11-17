import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions (Consistent) ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // Scaffold Background
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color borderGrey = Color(0xFFE0E0E0);
const Color warningOrange = Color(0xFFFF9800); // For Awaiting status
const Color successGreen = Color(0xFF4CAF50); // For Session status

// --- Data Models ---

enum SessionType { video, chat, inPerson }

enum SessionStatus { upcoming, past, cancelled, awaitingConfirmation }

class Booking {
  final String id;
  final String learnerName; // Renamed for mentor's view
  final String skillTopic;
  final DateTime originalDateTime; // Changed to clearly state it's the original
  final SessionType type;
  SessionStatus status;
  DateTime? proposedDateTime; // New field for reschedule proposal
  String mentorMessage; // New field for mentor's message

  Booking({
    required this.id,
    required this.learnerName,
    required this.skillTopic,
    required this.originalDateTime,
    required this.type,
    this.status = SessionStatus.upcoming,
    this.proposedDateTime,
    this.mentorMessage = '',
  });

  // Helper to get the display date
  DateTime get currentDateTime => proposedDateTime ?? originalDateTime;
}

// --- Sample Data ---
final Booking mockBooking = Booking(
  id: 'B001',
  learnerName: 'Alex Johnson', // The person the mentor is meeting
  skillTopic: 'Advanced Flutter State Management',
  originalDateTime: DateTime.now().add(const Duration(days: 3, hours: 10)),
  type: SessionType.video,
);

// Mock availability slots for the mentor (example times)
final List<String> _availableSlots = [
  '9:00 AM',
  '10:30 AM',
  '1:00 PM',
  '2:30 PM',
  '4:00 PM',
  '5:30 PM',
];

// ----------------------------------------------------------------------------
// 1. Reschedule Session Screen
// ----------------------------------------------------------------------------

class RescheduleSessionScreen extends StatefulWidget {
  final Booking booking;
  const RescheduleSessionScreen({super.key, required this.booking});

  @override
  State<RescheduleSessionScreen> createState() => _RescheduleSessionScreenState();
}

class _RescheduleSessionScreenState extends State<RescheduleSessionScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTimeSlot;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Function to show the Date Picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(hours: 1)), // Cannot pick current time
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: deepIndigo, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: darkGreyText, // Text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        // Ensure time component is reset to midnight
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
        _selectedTimeSlot = null; // Reset time slot on new date selection
      });
    }
  }

  // Handle the mentor proposing the new time
  void _proposeReschedule() {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a new time slot to propose.')),
      );
      return;
    }

    // 1. Parse the new date and time
    final List<String> parts = _selectedTimeSlot!.split(RegExp(r'[:\s]'));
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final isPM = parts[2] == 'PM';

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0; // Midnight case
    }

    final newDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, hour, minute);

    // 2. Update the booking object (mock data update)
    widget.booking.proposedDateTime = newDateTime;
    widget.booking.mentorMessage = _messageController.text;
    widget.booking.status = SessionStatus.awaitingConfirmation;

    logger.i(
        'Mentor proposed reschedule for session ${widget.booking.id} to ${newDateTime.toIso8601String()} with message: ${widget.booking.mentorMessage}');

    // 3. Show confirmation screen/dialog
    _showConfirmationDialog();
  }

  // --- Confirmation Dialog ---
  void _showConfirmationDialog() {
    final DateFormat fullFormatter = DateFormat('EEE, MMM d, yyyy');
    final DateFormat timeFormatter = DateFormat('h:mm a');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.watch_later_outlined, color: warningOrange),
            SizedBox(width: 8),
            Text('Proposal Sent', style: TextStyle(color: deepIndigo, fontSize: 20)),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text("You've proposed a new time for this session. The learner has been notified.",
                  style: TextStyle(color: darkGreyText, fontSize: 14)),
              const Divider(height: 25),
              // Original Time
              _confirmationRow('Original Time:',
                  '${fullFormatter.format(widget.booking.originalDateTime)} at ${timeFormatter.format(widget.booking.originalDateTime)}',
                  deepIndigo.withAlpha((0.7 * 255).toInt())),
              const SizedBox(height: 10),
              // New Proposed Time
              _confirmationRow('New Proposed Time:',
                  '${fullFormatter.format(widget.booking.proposedDateTime!)} at ${timeFormatter.format(widget.booking.proposedDateTime!)}',
                  vibrantCyan),
              const SizedBox(height: 15),
              // Status
              _confirmationRow('Status:', 'Awaiting Learner Confirmation', warningOrange),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to session list
            },
            child: const Text('Close', style: TextStyle(color: vibrantCyan, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _confirmationRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: darkGreyText)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // --- Current Session Card ---
  Widget _buildCurrentSessionCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.15 * 255).toInt()),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Session to Reschedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: deepIndigo)),
          const Divider(height: 16, color: borderGrey),
          _detailRow('Learner', widget.booking.learnerName, Icons.person_outline, deepIndigo), // Learner's Name
          _detailRow('Topic', widget.booking.skillTopic, Icons.topic, vibrantCyan),
          _detailRow(
            'Original Date & Time',
            '${DateFormat.yMMMEd().format(widget.booking.originalDateTime)} at ${DateFormat.jm().format(widget.booking.originalDateTime)}',
            Icons.access_time_filled,
            warningOrange,
          ),
          _detailRow(
            'Type',
            widget.booking.type.toString().split('.').last.toUpperCase(),
            widget.booking.type == SessionType.video ? Icons.videocam : Icons.chat_bubble_outline,
            successGreen,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: darkGreyText)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: darkGreyText, fontWeight: FontWeight.normal))),
        ],
      ),
    );
  }

  // --- Optional Message Input ---
  Widget _buildOptionalMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Optional Message to Learner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 10),
        TextField(
          controller: _messageController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'e.g., "I apologize for the change, I have a conflict on the original date."',
            hintStyle: TextStyle(color: darkGreyText.withAlpha((0.6 * 255).toInt())),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: deepIndigo, width: 2),
            ),
            filled: true,
            fillColor: cardBackground,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMEd();

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text('Propose Session Reschedule'),
        backgroundColor: deepIndigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Session Info
            _buildCurrentSessionCard(),
            
            // --- 1. Date Selection ---
            const Text('Select New Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatter.format(_selectedDate),
                      style: const TextStyle(fontSize: 16, color: darkGreyText, fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.calendar_month, color: deepIndigo),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // --- 2. Time Slot Selection (Mentor Availability) ---
            Text('Select New Time Slot on ${formatter.format(_selectedDate)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: _availableSlots.length,
              itemBuilder: (context, index) {
                final slot = _availableSlots[index];
                final isSelected = slot == _selectedTimeSlot;

                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTimeSlot = slot;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? vibrantCyan : cardBackground,
                    foregroundColor: isSelected ? Colors.white : deepIndigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? vibrantCyan : deepIndigo.withAlpha((0.3 * 255).toInt()),
                        width: 1.5,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: isSelected ? 3 : 0,
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // --- 3. Optional Message ---
            _buildOptionalMessage(),

            const SizedBox(height: 40),

            // --- Action Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _selectedTimeSlot != null ? _proposeReschedule : null,
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                label: const Text('Propose New Time', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: vibrantCyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: vibrantCyan.withAlpha((0.5 * 255).toInt()),
                  disabledForegroundColor: Colors.white70,
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 2. Mock Bookings List Screen (Entry Point)
// ----------------------------------------------------------------------------

class MockBookingsListScreen extends StatelessWidget {
  const MockBookingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor - My Bookings (Mock)'),
        backgroundColor: deepIndigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withAlpha((0.2 * 255).toInt()), blurRadius: 5)
                ]
              ),
              child: Text(
                'Upcoming Session with Learner: ${mockBooking.learnerName}\nTopic: ${mockBooking.skillTopic}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: darkGreyText),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: vibrantCyan,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Navigate to the Reschedule screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RescheduleSessionScreen(booking: mockBooking),
                  ),
                );
              },
              icon: const Icon(Icons.update, color: Colors.white),
              label: const Text('Reschedule Session', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
