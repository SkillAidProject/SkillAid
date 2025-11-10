import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// --- Color and Style Definitions from Profile Screen ---
const Color deepIndigo = Color(0xFF3F51B5); // Main Primary Color
const Color vibrantCyan = Color(0xFF00BCD4); // Main Accent Color
const Color lightBackground = Color(0xFFF7F8FC); // New, soft background
const Color darkGreyText = Color(0xFF5A5A5A);
const Color successGreen = Color(0xFF4CAF50); // For progress
const Color streakOrange = Color(0xFFFF9800); // For streaks/highlights

// --- Data Model for Certificates ---
class Certificate {
  final String title;
  final String issuer;
  final DateTime dateCompleted;
  final String credentialId;
  final IconData icon;
  final String certificateUrl; // NEW: URL for download

  Certificate({
    required this.title,
    required this.issuer,
    required this.dateCompleted,
    required this.credentialId,
    required this.icon,
    required this.certificateUrl, // Included in constructor
  });
}

// --- Sample Data (with mock URLs) ---
final List<Certificate> mockCertificates = [
  Certificate(
    title: 'Advanced Data Science',
    issuer: 'SkillAid Academy',
    dateCompleted: DateTime(2025, 10, 15),
    credentialId: 'SA-DS-2025-481',
    icon: Icons.analytics_outlined,
    certificateUrl: 'https://cdn.example.com/certificates/data-science.pdf',
  ),
  Certificate(
    title: 'Leadership & Team Building',
    issuer: 'SoftSkills Pro',
    dateCompleted: DateTime(2025, 09, 01),
    credentialId: 'SS-LB-2025-102',
    icon: Icons.people_alt_outlined,
    certificateUrl: 'https://cdn.example.com/certificates/leadership.pdf',
  ),
  Certificate(
    title: 'Flutter App Development',
    issuer: 'Mobile Dev Hub',
    dateCompleted: DateTime(2025, 07, 22),
    credentialId: 'MD-FLT-2025-305',
    icon: Icons.phone_android_outlined,
    certificateUrl: 'https://cdn.example.com/certificates/flutter-dev.pdf',
  ),
  Certificate(
    title: 'Cloud Computing Fundamentals',
    issuer: 'Tech Masters',
    dateCompleted: DateTime(2025, 05, 10),
    credentialId: 'TM-CCF-2025-019',
    icon: Icons.cloud_outlined,
    certificateUrl: 'https://cdn.example.com/certificates/cloud-fundamentals.pdf',
  ),
];

// ----------------------------------------------------------------------------
// 1. Download Logic
// ----------------------------------------------------------------------------

/// Mock function to simulate a file download and give user feedback.
void _downloadCertificate(BuildContext context, Certificate certificate) async {
  logger.i('Attempting to download certificate: ${certificate.certificateUrl}');

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('⏳ Preparing your certificate for download...'),
      duration: Duration(seconds: 2),
    ),
  );

  // Simulate network delay and file download process
  await Future.delayed(const Duration(seconds: 3));

  if (context.mounted) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Download Complete: "${certificate.title}" PDF saved!'),
        backgroundColor: successGreen,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 2. Certificate Card Widget (Updated with Download Button)
// ----------------------------------------------------------------------------

class CertificateCard extends StatelessWidget {
  final Certificate certificate;

  const CertificateCard({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    // Determine gradient color based on the icon (for visual variety)
    final List<Color> gradientColors = [
      deepIndigo.withAlpha((0.9 * 255).toInt()),
      deepIndigo,
    ];

    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Use an attractive linear gradient for a premium look
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Prominent Icon
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                certificate.icon,
                color: vibrantCyan.withAlpha((0.8 * 255).toInt()),
                size: 40,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Certificate Title (Bold and Clear)
                Text(
                  certificate.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // 3. Issuer Name (Subtle and Professional)
                Text(
                  'Issued by ${certificate.issuer}',
                  style: TextStyle(
                    color: Colors.white.withAlpha((0.8 * 255).toInt()),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // 4. Footer with Date and Download Button (New)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  certificate.dateCompleted.year.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // --- DOWNLOAD BUTTON IMPLEMENTATION ---
                ElevatedButton.icon(
                  onPressed: () => _downloadCertificate(context, certificate),
                  // icon: const Icon(Icons.download, color: Colors.white, size: 18),
                  label: const Text('Download', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vibrantCyan,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    elevation: 0,
                    minimumSize: Size.zero, // Minimal size for compact look
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 3. Certificates Screen Implementation (Unchanged)
// ----------------------------------------------------------------------------

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        title: const Text(
          'My Certifications',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.share_outlined),
        //     onPressed: () {
        //       logger.i('Share all certificates');
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('Preparing Portfolio Share (Mock)')),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Text(
              'Your Achievements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: deepIndigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A collection of your hard-earned certificates and credentials.',
              style: TextStyle(
                fontSize: 14,
                color: darkGreyText,
              ),
            ),
            const SizedBox(height: 20),

            // Certificates Grid View
            GridView.builder(
              shrinkWrap: true, // Allows GridView inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8, // Adjust height/width ratio
              ),
              itemCount: mockCertificates.length,
              itemBuilder: (context, index) {
                return CertificateCard(certificate: mockCertificates[index]);
              },
            ),

            const SizedBox(height: 40),

            // Call to Action / Information Section
            _buildInfoTile(
              icon: Icons.history_edu,
              title: 'Credential Verification',
              subtitle: 'All credentials are verifiable via their unique ID.',
              color: vibrantCyan,
            ),
            // const SizedBox(height: 12),
            // _buildInfoTile(
            //   icon: Icons.school_outlined,
            //   title: 'New Programs Available',
            //   subtitle: 'Ready for your next achievement? Explore new courses now!',
            //   color: successGreen,
            //   onTap: () {
            //     logger.i('Navigate to programs');
            //     Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ProgramsScreen()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // Helper widget for bottom info tiles
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha((0.15 * 255).toInt()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: darkGreyText.withAlpha((0.8 * 255).toInt())),
        ),
        trailing: onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16, color: darkGreyText) : null,
      ),
    );
  }
}