import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions (Inherited from previous screens) ---
const Color deepIndigo = Color(0xFF3F51B5); // Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // Scaffold Background
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50); // For read status/success
const Color redAccent = Color(0xFFE53935); // For delete action
const Color borderGrey = Color(0xFFE0E0E0);
const Color unreadDotColor = Color(0xFFFF7043); // Orange for visual pop

// --- Notification Type Enum ---
enum NotificationType {
  mentorship,
  courseUpdate,
  achievement,
  systemAlert,
  all,
}

// --- Data Model for a Single Notification ---
class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String shortDescription;
  final DateTime timestamp;
  final String actionText;
  final IconData icon;
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.shortDescription,
    required this.timestamp,
    required this.actionText,
    required this.icon,
    this.isRead = false,
  });
}

// --- Sample Data ---
List<AppNotification> initialNotifications = [
  AppNotification(
    id: 'n1',
    type: NotificationType.mentorship,
    title: 'Session Reminder: Data Viz',
    shortDescription: 'Your 1-on-1 session with Jane Doe starts in 15 minutes.',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    actionText: 'Join Session',
    icon: Icons.video_call_outlined,
    isRead: false,
  ),
  AppNotification(
    id: 'n2',
    type: NotificationType.courseUpdate,
    title: 'New Lesson in Flutter Dev',
    shortDescription: 'Module 3: State Management is now available!',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    actionText: 'View Lesson',
    icon: Icons.class_outlined,
    isRead: false,
  ),
  AppNotification(
    id: 'n3',
    type: NotificationType.achievement,
    title: 'New Badge Unlocked!',
    shortDescription: 'You earned the "Code Ninja" badge for completing 5 projects.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    actionText: 'View Profile',
    icon: Icons.star_border,
    isRead: false,
  ),
  AppNotification(
    id: 'n4',
    type: NotificationType.mentorship,
    title: 'Mentor Reply Received',
    shortDescription: 'Jane Doe replied to your question about null safety.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    actionText: 'View Reply',
    icon: Icons.quick_contacts_mail_outlined,
    isRead: true,
  ),
  AppNotification(
    id: 'n5',
    type: NotificationType.systemAlert,
    title: 'App Update Available (v2.1)',
    shortDescription: 'New features and security patches have been released.',
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
    actionText: 'Update Now',
    icon: Icons.system_update_alt_outlined,
    isRead: false,
  ),
];

// --- Utility for Time Formatting ---
String formatTimeAgo(DateTime timestamp) {
  final duration = DateTime.now().difference(timestamp);
  if (duration.inMinutes < 60) {
    return '${duration.inMinutes}m ago';
  } else if (duration.inHours < 24) {
    return '${duration.inHours}h ago';
  } else if (duration.inDays < 7) {
    return '${duration.inDays}d ago';
  } else {
    return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
  }
}

// --- Utility for Icon/Color based on Type (FIXED: Explicitly returning Map<String, dynamic>) ---
Map<String, dynamic> getNotificationStyle(NotificationType type) {
  switch (type) {
    case NotificationType.mentorship:
      return {'icon': Icons.group, 'color': deepIndigo, 'badge': 'Mentorship'};
    case NotificationType.courseUpdate:
      return {'icon': Icons.book, 'color': vibrantCyan, 'badge': 'Course'};
    case NotificationType.achievement:
      return {'icon': Icons.emoji_events, 'color': successGreen, 'badge': 'Achievement'};
    case NotificationType.systemAlert:
      return {'icon': Icons.settings, 'color': redAccent, 'badge': 'System'};
    default:
      return {'icon': Icons.notifications, 'color': Colors.grey, 'badge': 'Alert'};
  }
}

// ----------------------------------------------------------------------------
// 1. Notification Card Widget (Supports Swipe and Status)
// ----------------------------------------------------------------------------

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTapAction;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTapAction,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> style = getNotificationStyle(notification.type);
    final bool isUnread = !notification.isRead;

    // Background for swipe-to-delete (right-to-left swipe)
    final Widget deleteBackground = Container(
      alignment: Alignment.centerRight,
      color: redAccent,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(Icons.delete_sweep, color: Colors.white),
    );

    // Background for swipe-to-mark-read/unread (left-to-right swipe)
    final Widget markBackground = Container(
      alignment: Alignment.centerLeft,
      color: isUnread ? successGreen : deepIndigo,
      padding: const EdgeInsets.only(left: 20.0),
      child: Icon(isUnread ? Icons.mark_email_read : Icons.mark_email_unread, color: Colors.white),
    );

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.horizontal,
      background: markBackground,
      secondaryBackground: deleteBackground,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swipe left to delete
          onDelete();
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          // Swipe right to mark read/unread
          onMarkRead();
          // Returning false keeps the item in the list after state update
          return false;
        }
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: borderGrey, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread Status Dot
            Padding(
              padding: const EdgeInsets.only(top: 6.0, right: 10.0),
              child: isUnread
                  ? const Icon(Icons.circle, color: unreadDotColor, size: 10)
                  : const SizedBox(width: 10),
            ),
            
            // Icon or Type Badge
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (style['color'] as Color).withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style['icon'], color: style['color'], size: 24),
            ),
            const SizedBox(width: 12),

            // Content Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                            color: isUnread ? Colors.black87 : darkGreyText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Timestamp
                      Text(
                        formatTimeAgo(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: darkGreyText.withAlpha((0.6 * 255).toInt()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Short Description
                  Text(
                    notification.shortDescription,
                    style: const TextStyle(
                      fontSize: 13,
                      color: darkGreyText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Action Button
                  SizedBox(
                    height: 30, // Limit height for compact button
                    child: ElevatedButton(
                      onPressed: onTapAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vibrantCyan,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        notification.actionText,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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

// ----------------------------------------------------------------------------
// 2. Notifications Screen (Stateful for Tabs and Read/Unread Status)
// ----------------------------------------------------------------------------

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<AppNotification> _notifications;

  final List<String> _tabs = [
    'All',
    'Mentorship',
    'Course Updates',
    'Achievements',
    'System Alerts',
  ];

  @override
  void initState() {
    super.initState();
    _notifications = initialNotifications;
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- State Management Functions ---

  List<AppNotification> _getFilteredNotifications(NotificationType type) {
    if (type == NotificationType.all) {
      // Sort by unread first, then by timestamp
      final sortedList = _notifications.toList()
        ..sort((a, b) {
          if (a.isRead != b.isRead) {
            return a.isRead ? 1 : -1; // Unread (-1) comes before read (1)
          }
          return b.timestamp.compareTo(a.timestamp); // Newest first
        });
      return sortedList;
    }
    // Filter by type
    return _notifications.where((n) => n.type == type).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first for filtered tabs
  }

  void _markReadToggle(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].isRead = !_notifications[index].isRead;
      }
    });
    logger.i('Notification $id marked as ${_notifications.firstWhere((n) => n.id == id).isRead ? 'read' : 'unread'}');
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    // Use a SnackBar for confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted.'),
        duration: Duration(seconds: 1),
      ),
    );
    logger.i('Notification $id deleted');
  }

  void _handleAction(AppNotification notification) {
    // Mock handler for action button taps
    logger.i('Action tap: ${notification.actionText} for ${notification.title}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: "${notification.actionText}" triggered! (Mock)'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Mark as read when action is taken
    if (!notification.isRead) {
      _markReadToggle(notification.id);
    }
  }

  // --- UI Builder ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: deepIndigo),
                insets: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              labelColor: deepIndigo,
              unselectedLabelColor: darkGreyText,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: _tabs.map((name) => Tab(text: name)).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
              logger.i('All notifications marked as read.');
            },
            child: const Text(
              'Mark All Read',
              style: TextStyle(color: vibrantCyan, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Notifications Tab
          _buildNotificationList(_getFilteredNotifications(NotificationType.all)),
          // Mentorship Tab
          _buildNotificationList(_getFilteredNotifications(NotificationType.mentorship)),
          // Course Updates Tab
          _buildNotificationList(_getFilteredNotifications(NotificationType.courseUpdate)),
          // Achievements Tab
          _buildNotificationList(_getFilteredNotifications(NotificationType.achievement)),
          // System Alerts Tab
          _buildNotificationList(_getFilteredNotifications(NotificationType.systemAlert)),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<AppNotification> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: borderGrey),
            SizedBox(height: 10),
            Text('No notifications here!', style: TextStyle(color: darkGreyText, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationCard(
          notification: notification,
          onTapAction: () => _handleAction(notification),
          onMarkRead: () => _markReadToggle(notification.id),
          onDelete: () => _deleteNotification(notification.id),
        );
      },
    );
  }
}