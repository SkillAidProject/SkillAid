import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions (Consistent with previous screens) ---
const Color primaryBlue = Color(0xFF1E88E5);
const Color deepIndigo = Color(0xFF3F51B5); 
const Color vibrantCyan = Color(0xFF00BCD4);
const Color lightBackground = Color(0xFFF7F8FC); 
const Color cardBackground = Colors.white;
const Color darkGreyText = Color(0xFF5A5A5A);
const Color borderGrey = Color(0xFFE0E0E0);
const Color redAccent = Color(0xFFE53935);
const Color successGreen = Color(0xFF4CAF50);
const Color accentYellow = Color(0xFFFFC107); // For storage indicator
const Color tagSoftSkills = Color(0xFFE0F2F7);
const Color tagTechnical = Color(0xFFFFF3E0);
const Color tagVocational = Color(0xFFE8F5E9);

// --- Data Models ---

enum FileType { video, pdf, audio, cheatsheet }

class LearnerFile {
  final String id;
  final String title;
  final String skillTag;
  final String mentor;
  final FileType type;
  final DateTime dateAdded;
  final double sizeMB;
  final bool isSaved; // Saved Lesson
  final bool isDownloaded; // Offline Download

  LearnerFile({
    required this.id,
    required this.title,
    required this.skillTag,
    required this.mentor,
    required this.type,
    required this.dateAdded,
    required this.sizeMB,
    this.isSaved = false,
    this.isDownloaded = false,
  });

  IconData get icon {
    switch (type) {
      case FileType.video:
        return Icons.videocam_rounded;
      case FileType.pdf:
        return Icons.picture_as_pdf_rounded;
      case FileType.audio:
        return Icons.headset_rounded;
      case FileType.cheatsheet:
        return Icons.description_rounded;
    }
  }

  Color get tagColor {
    switch (skillTag) {
      case 'Technical':
        return tagTechnical;
      case 'Soft Skills':
        return tagSoftSkills;
      case 'Vocational':
        return tagVocational;
      default:
        return borderGrey;
    }
  }
}

// --- Sample Data ---
final List<LearnerFile> mockFiles = [
  LearnerFile(
    id: '1',
    title: 'Python Async Programming Basics',
    skillTag: 'Technical',
    mentor: 'Jane Doe',
    type: FileType.video,
    dateAdded: DateTime(2025, 10, 20),
    sizeMB: 150.5,
    isSaved: true,
    isDownloaded: true,
  ),
  LearnerFile(
    id: '2',
    title: 'Effective Communication Workbook',
    skillTag: 'Soft Skills',
    mentor: 'John Smith',
    type: FileType.pdf,
    dateAdded: DateTime(2025, 10, 15),
    sizeMB: 5.2,
    isSaved: true,
    isDownloaded: false,
  ),
  LearnerFile(
    id: '3',
    title: 'Woodworking Safety Procedures',
    skillTag: 'Vocational',
    mentor: 'Alex Lee',
    type: FileType.audio,
    dateAdded: DateTime(2025, 10, 10),
    sizeMB: 22.8,
    isSaved: false,
    isDownloaded: true,
  ),
  LearnerFile(
    id: '4',
    title: 'Advanced SQL Cheatsheet',
    skillTag: 'Technical',
    mentor: 'Jane Doe',
    type: FileType.cheatsheet,
    dateAdded: DateTime(2025, 10, 05),
    sizeMB: 0.1,
    isSaved: true,
    isDownloaded: true,
  ),
  LearnerFile(
    id: '5',
    title: 'Negotiation Tactics Mini-Course',
    skillTag: 'Soft Skills',
    mentor: 'John Smith',
    type: FileType.video,
    dateAdded: DateTime(2025, 9, 28),
    sizeMB: 98.7,
    isSaved: false,
    isDownloaded: true,
  ),
];

// --- Main Screen Implementation ---

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedFileIds = {};
  FileType? _fileTypeFilter;

  // Mock data for the two tabs
  late List<LearnerFile> _savedLessons;
  late List<LearnerFile> _offlineDownloads;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _initializeMockData();
  }

  void _initializeMockData() {
    // Filter mock data for the two tabs
    _savedLessons = mockFiles.where((file) => file.isSaved).toList();
    _offlineDownloads = mockFiles.where((file) => file.isDownloaded).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _toggleSelection(String fileId) {
    setState(() {
      if (_selectedFileIds.contains(fileId)) {
        _selectedFileIds.remove(fileId);
      } else {
        _selectedFileIds.add(fileId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedFileIds.clear();
    });
  }

  void _performBulkAction(String action) {
    if (_selectedFileIds.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action ${_selectedFileIds.length} file(s) (Mock Action)'),
        backgroundColor: primaryBlue,
      ),
    );
    _clearSelection();
  }

  void _showFilterMenu() {
    final ValueNotifier<FileType?> selectedFilterNotifier = ValueNotifier<FileType?>(_fileTypeFilter);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by File Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(),
                  // Using ValueListenableBuilder for the radio group
                  ValueListenableBuilder<FileType?>(
                    valueListenable: selectedFilterNotifier,
                    builder: (context, selectedValue, child) {
                      return Column(
                        children: FileType.values.map((type) {
                          return RadioListTile<FileType>(
                            title: Text(type.toString().split('.').last.toUpperCase()),
                            value: type,
                            groupValue: selectedValue, // Use the ValueNotifier value
                            onChanged: (FileType? value) {
                              selectedFilterNotifier.value = value;
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            selectedFilterNotifier.value = null;
                          });
                          setState(() {
                            _fileTypeFilter = null;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear Filter', style: TextStyle(color: redAccent)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _fileTypeFilter = selectedFilterNotifier.value;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                        child: const Text('Apply', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<LearnerFile> _getFilteredFiles(List<LearnerFile> files) {
    List<LearnerFile> filtered = files;

    // 1. Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((file) {
        final query = _searchQuery;
        return file.title.toLowerCase().contains(query) ||
            file.skillTag.toLowerCase().contains(query) ||
            file.mentor.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Apply Type Filter
    if (_fileTypeFilter != null) {
      filtered = filtered.where((file) => file.type == _fileTypeFilter).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final bool isInSelectionMode = _selectedFileIds.isNotEmpty;

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: _buildAppBar(isInSelectionMode),
      body: Column(
        children: [
          if (!isInSelectionMode && _tabController.index == 1) _buildStorageIndicator(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFileListView(_savedLessons, 'Saved Lessons'),
                _buildFileListView(_offlineDownloads, 'Offline Downloads'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isInSelectionMode ? _buildBulkActionToolbar() : null,
    );
  }

  // --- UI Components ---

  AppBar _buildAppBar(bool isInSelectionMode) {
    if (isInSelectionMode) {
      return AppBar(
        backgroundColor: primaryBlue,
        title: Text('${_selectedFileIds.length} Selected', style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _clearSelection,
        ),
      );
    }

    return AppBar(
      backgroundColor: cardBackground,
      surfaceTintColor: cardBackground,
      elevation: 0,
      title: const Text('My Files', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      iconTheme: const IconThemeData(color: Colors.black87),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, topic, or mentor',
                    prefixIcon: const Icon(Icons.search, color: darkGreyText),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: lightBackground,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterMenu,
                  tooltip: 'Filter Files',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: cardBackground,
      child: TabBar(
        controller: _tabController,
        indicatorColor: primaryBlue,
        labelColor: primaryBlue,
        unselectedLabelColor: darkGreyText,
        onTap: (index) {
          setState(() {
            _clearSelection(); // Clear selection when switching tabs
          });
        },
        tabs: const [
          Tab(text: 'Saved Lessons'),
          Tab(text: 'Offline Downloads'),
        ],
      ),
    );
  }

  Widget _buildStorageIndicator() {
    // Mock Storage Calculation
    const double totalStorage = 500.0; // Mock 500MB available
    final double currentUsed = _offlineDownloads.fold(0.0, (sum, file) => sum + file.sizeMB);
    final double percentageUsed = (currentUsed / totalStorage).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Offline Storage',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percentageUsed,
            backgroundColor: lightBackground,
            valueColor: AlwaysStoppedAnimation<Color>(percentageUsed > 0.8 ? redAccent : accentYellow),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentUsed.toStringAsFixed(1)} MB Used of ${totalStorage.toStringAsFixed(0)} MB',
                style: const TextStyle(fontSize: 13, color: darkGreyText),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Storage Management Screen Opened (Mock)')),
                  );
                },
                child: const Text(
                  'Manage Storage',
                  style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileListView(List<LearnerFile> files, String emptyMessageTitle) {
    final filteredFiles = _getFilteredFiles(files);

    if (filteredFiles.isEmpty) {
      return _buildEmptyState(emptyMessageTitle);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      itemCount: filteredFiles.length,
      itemBuilder: (context, index) {
        final file = filteredFiles[index];
        final isSelected = _selectedFileIds.contains(file.id);
        final bool isOfflineTab = _tabController.index == 1;

        return FileCard(
          file: file,
          isSelected: isSelected,
          onTap: () {
            if (_selectedFileIds.isNotEmpty) {
              _toggleSelection(file.id);
            } else {
              _showFileActionModal(file, isOfflineTab);
            }
          },
          onLongPress: () => _toggleSelection(file.id),
          onDelete: () => _deleteFile(file),
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sharing link for: ${file.title}')),
            );
          },
        );
      },
    );
  }

  void _showFileActionModal(LearnerFile file, bool isOfflineTab) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(file.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(height: 20),
              ListTile(
                leading: const Icon(Icons.open_in_new, color: primaryBlue),
                title: const Text('Open Lesson'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening lesson: ${file.title}')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: vibrantCyan),
                title: const Text('Share Link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sharing link for: ${file.title}')),
                  );
                },
              ),
              if (isOfflineTab)
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: redAccent),
                  title: const Text('Delete Download'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteFile(file);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.bookmark_remove, color: redAccent),
                  title: const Text('Unsave Lesson'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteFile(file);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _deleteFile(LearnerFile file) {
    setState(() {
      _savedLessons.removeWhere((f) => f.id == file.id);
      _offlineDownloads.removeWhere((f) => f.id == file.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File deleted: ${file.title}')),
    );
  }

  Widget _buildEmptyState(String messageTitle) {
    String message = messageTitle == 'Saved Lessons'
        ? 'No saved lessons yet. Bookmark lessons to view them here!'
        : 'No offline downloads. Download files to access them without an internet connection.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.folder_open, size: 80, color: darkGreyText.withAlpha((0.3 * 255).toInt())),
            const SizedBox(height: 20),
            Text(
              messageTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreyText),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: darkGreyText.withAlpha((0.7 * 255).toInt())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkActionToolbar() {
    return Container(
      color: primaryBlue,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBulkActionButton(Icons.delete, 'Delete', () => _performBulkAction('Deleting')),
          _buildBulkActionButton(Icons.folder_special, 'Move', () => _performBulkAction('Moving')),
          _buildBulkActionButton(Icons.share, 'Share', () => _performBulkAction('Sharing')),
        ],
      ),
    );
  }

  Widget _buildBulkActionButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// --- Custom File Card Widget ---

class FileCard extends StatelessWidget {
  final LearnerFile file;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const FileCard({
    super.key,
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected ? const BorderSide(color: primaryBlue, width: 2) : BorderSide.none,
      ),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Selection Indicator
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.check_circle, color: primaryBlue),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.circle_outlined, color: darkGreyText.withAlpha((0.5 * 255).toInt())),
                ),

              // Thumbnail/Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: file.tagColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(file.icon, color: primaryBlue.withAlpha((0.8 * 255).toInt()), size: 28),
              ),

              const SizedBox(width: 12),

              // File Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTag(file.skillTag, file.tagColor),
                        const SizedBox(width: 8),
                        Text(
                          '${file.sizeMB.toStringAsFixed(1)} MB',
                          style: const TextStyle(fontSize: 12, color: darkGreyText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Added: ${file.dateAdded.day}/${file.dateAdded.month}/${file.dateAdded.year}',
                      style: const TextStyle(fontSize: 12, color: darkGreyText),
                    ),
                  ],
                ),
              ),

              // Actions/Trailing Indicator
              if (!isSelected)
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'open') {
                      onTap();
                    } else if (result == 'delete') {
                      onDelete();
                    } else if (result == 'share') {
                      onShare();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'open',
                      child: Text('Open'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'share',
                      child: Text('Share'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: darkGreyText),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: darkGreyText.withAlpha((0.9 * 255).toInt()),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 5. App Wrapper for Single File Execution
// ----------------------------------------------------------------------------

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const SkillAidFileManagerApp());
// }

// class SkillAidFileManagerApp extends StatelessWidget {
//   const SkillAidFileManagerApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'SkillAid File Manager',
  //     theme: ThemeData(
  //       useMaterial3: false,
  //       primaryColor: primaryBlue,
  //       scaffoldBackgroundColor: lightBackground,
  //       fontFamily: 'Roboto',
  //       colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: vibrantCyan),
  //     ),
  //     home: const FileManagerScreen(),
  //   );
  // }
// }