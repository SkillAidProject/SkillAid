import 'package:flutter/material.dart';
import 'dart:async';
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
const Color redAccent = Color(0xFFE53935); // For End Call button
const Color successGreen = Color(0xFF4CAF50); // For Session status
const Color warningOrange = Color(0xFFFF9800); // For tech issues/warnings
const Color callBackground = Color(0xFF2C3E50); // Dark background for video feeds

// --- Data Models ---

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

// --- Mock Data ---
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

// ----------------------------------------------------------------------------
// 1. Live Session Screen (Stateful Widget)
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

  // Helper to format Duration into MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // --- Session Flow Logic ---

  void _startLobbyCountdown() {
    _sessionTimeRemaining = widget.session.scheduledTime.difference(DateTime.now());
    if (_sessionTimeRemaining.isNegative) {
      _sessionTimeRemaining = Duration.zero; // Start immediately if past due
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
          // Automatically transition to in-call mode when the countdown hits zero
          _currentState = SessionState.lobby; // Still in lobby until user clicks join
        }
      });
    });
  }

  void _joinSession() {
    _timer?.cancel();
    setState(() {
      _currentState = SessionState.inCall;
      // Start the in-call timer (e.g., 30 seconds for demo, then go to post-call)
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
    // Mock save operation
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
        automaticallyImplyLeading: _currentState == SessionState.lobby, // Only show back button in lobby
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

  // ----------------------------------------------------------------------------
  // 2. Pre-Session Lobby Screen
  // ----------------------------------------------------------------------------

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
              // Countdown Timer
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

                      // Join Button (Disabled until time is up)
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

              // Session Details Card
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

              // Tech Check Panel
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

  // ----------------------------------------------------------------------------
  // 3. Live Session Interface
  // ----------------------------------------------------------------------------

  Widget _buildInCallScreen() {
    return Row(
      children: [
        // Main Content Area (Video/Audio)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Video Feeds
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: callBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.2 * 255).toInt()), blurRadius: 10)],
                    ),
                    child: Stack(
                      children: [
                        // Learner's Main Video Feed Placeholder
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
                        // Mentor's Small Preview
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

                // Call Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mute Toggle
                      _buildCallControl(
                        _isMicOn ? Icons.mic : Icons.mic_off,
                        _isMicOn ? 'Mute' : 'Unmute',
                        _isMicOn ? Colors.white : redAccent,
                        () => setState(() => _isMicOn = !_isMicOn),
                      ),
                      // Camera Toggle
                      _buildCallControl(
                        _isCameraOn ? Icons.videocam : Icons.videocam_off,
                        _isCameraOn ? 'Camera Off' : 'Camera On',
                        _isCameraOn ? Colors.white : redAccent,
                        () => setState(() => _isCameraOn = !_isCameraOn),
                      ),
                      // Screen Share
                      _buildCallControl(
                        Icons.screen_share,
                        'Share Screen',
                        Colors.white,
                        () {},
                        isPrimary: true,
                      ),
                      // Chat
                      _buildCallControl(
                        Icons.chat_bubble_outline,
                        'Chat',
                        Colors.white,
                        () {
                          // Mock open chatbox
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chat box is now active.')),
                          );
                        },
                      ),
                      const Spacer(),
                      // End Session Button
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

        // Notes Panel
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

  // ----------------------------------------------------------------------------
  // 4. Post-Session Summary Screen
  // ----------------------------------------------------------------------------

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

                // Post-Session Actions
                _buildSummaryActionButton(
                  icon: Icons.edit_note,
                  label: 'Add/Review Session Notes',
                  description: 'Finalize the key takeaways and action items.',
                  color: vibrantCyan,
                  onPressed: () {
                    // Mock action
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
                    // Mock action
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
                    // Mock action
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
// 5. App Wrapper for Single File Execution
// ----------------------------------------------------------------------------

void main() {
  // To avoid runtime error in the buildActionTile mock functionality,
  // we ensure Flutter bindings are initialized before calling runApp.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SkillAidLiveSessionApp());
}

class SkillAidLiveSessionApp extends StatelessWidget {
  const SkillAidLiveSessionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillAid Live Session',
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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: vibrantCyan),
      ),
      home: LiveSessionScreen(session: mockSession),
    );
  }
}