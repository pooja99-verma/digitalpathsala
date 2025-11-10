// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'admin_attendance_screen.dart';
// import 'register_screen.dart';
// import 'run_migration_screen.dart';
// import 'role_selection_screen.dart'; // 👈 Navigate back here after logout
//
// class AdminDashboardScreen extends StatefulWidget {
//   const AdminDashboardScreen({super.key});
//
//   @override
//   State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
// }
//
// class _AdminDashboardScreenState extends State<AdminDashboardScreen>
//     with SingleTickerProviderStateMixin {
//   Future<void> _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user_role'); // Clear stored role
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Admin Dashboard",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.redAccent,
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout),
//               tooltip: "Logout",
//               onPressed: () async {
//                 await _logout(context);
//               },
//             ),
//           ],
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             isScrollable: true,
//             tabs: [
//               Tab(icon: Icon(Icons.person_add), text: "Register Students"),
//               Tab(icon: Icon(Icons.check_circle), text: "Mark Attendance"),
//               Tab(icon: Icon(Icons.picture_as_pdf), text: "Notes"),
//               Tab(icon: Icon(Icons.sync), text: "Run Migration"),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             RegisterStudentsTab(),
//             MarkAttendanceTab(),
//             UploadPdfTab(),
//             RunMigrationTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RegisterStudentsTab extends StatelessWidget {
//   const RegisterStudentsTab({super.key});
//   @override
//   Widget build(BuildContext context) => const RegistrationScreen();
// }
//
// class MarkAttendanceTab extends StatelessWidget {
//   const MarkAttendanceTab({super.key});
//   @override
//   Widget build(BuildContext context) => AttendanceScreen();
//       //const AdminAttendanceScreen();
// }
//
// class UploadPdfTab extends StatelessWidget {
//   const UploadPdfTab({super.key});
//   @override
//   Widget build(BuildContext context) => UploadPdfTab();
// }
// class RunMigrationTab extends StatefulWidget {
//   const RunMigrationTab({super.key});
//
//   @override
//   State<RunMigrationTab> createState() => _RunMigrationTabState();
// }
//
// class _RunMigrationTabState extends State<RunMigrationTab> {
//   bool _isUploading = false;
//   String _statusMessage = '';
//
//   /// Upload Class 12 students with subjects from CSV
//   Future<void> uploadClass12StudentsWithSubjects() async {
//     final firestore = FirebaseFirestore.instance;
//
//     setState(() {
//       _isUploading = true;
//       _statusMessage = 'Uploading Class 12 students...';
//     });
//
//     try {
//       final csvData = await rootBundle.loadString('assets/Class_12_Students.csv');
//       final lines = const LineSplitter().convert(csvData);
//
//       int successCount = 0;
//       int errorCount = 0;
//
//       for (var i = 1; i < lines.length; i++) {
//         // Use regex to handle quoted commas correctly
//         final values = RegExp(r'(?:\"([^\"]*)\"|([^,]+))')
//             .allMatches(lines[i])
//             .map((m) => m.group(1) ?? m.group(2) ?? '')
//             .toList();
//
//         if (values.length < 4) continue;
//
//         final studentClass = values[0].trim();
//         final name = values[1].trim();
//         final subjectsRaw = values[2].trim();
//         final ui = values[3].trim();
//
//         if (ui.isEmpty || studentClass != '12th') continue;
//
//         final subjectList = subjectsRaw.split(',').map((s) => s.trim()).toList();
//
//         try {
//           await firestore.collection('students').doc(ui).set({
//             'NAME': name,
//             'CLASS': studentClass,
//             'SUBJECTS': subjectList,
//             'UI': ui,
//             'attendance': [],
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//
//           print('✅ Uploaded Class 12 student: $name ($ui)');
//           successCount++;
//         } catch (e) {
//           print('⚠️ Error uploading $name ($ui): $e');
//           errorCount++;
//         }
//       }
//
//       setState(() {
//         _statusMessage = '🎉 Uploaded $successCount Class 12 students. $errorCount errors.';
//       });
//     } catch (e) {
//       print('❌ Error uploading Class 12 students: $e');
//       setState(() {
//         _statusMessage = '❌ Upload failed. Check console for details.';
//       });
//     }
//
//     setState(() {
//       _isUploading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton.icon(
//             icon: const Icon(Icons.upload_file),
//             label: const Text('Upload Class 12 Students with Subjects'),
//             onPressed: _isUploading
//                 ? null
//                 : () async {
//               setState(() {
//                 _isUploading = true;
//                 _statusMessage = 'Uploading Class 12 students...';
//               });
//
//               await uploadClass12StudentsWithSubjects();
//
//               setState(() {
//                 _isUploading = false;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//           ),
//           const SizedBox(height: 20),
//           if (_isUploading) const CircularProgressIndicator(),
//           const SizedBox(height: 10),
//           Text(
//             _statusMessage,
//             style: const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//

import 'package:digital_pathsala/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_attendance_screen.dart';
import 'admin_fees_screen.dart';
import 'admin_notes_screen.dart';
import 'role_selection_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // ✅ Corrected to match number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () async {
                await _logout(context);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.person_add), text: "Register Students"),
              Tab(icon: Icon(Icons.check_circle), text: "Mark Attendance"),
              Tab(icon: Icon(Icons.picture_as_pdf), text: "Notes"),
              Tab(icon: Icon(Icons.currency_rupee), text: "Fees"), // ✅ Changed icon for clarity
              Tab(icon: Icon(Icons.sync), text: "Run Migration"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RegisterStudentsTab(),
            MarkAttendanceTab(),
            UploadPdfTab(),
            FeesTab(), // ✅ Added FeesTab
            RunMigrationTab(), // ✅ Added RunMigrationTab
          ],
        ),
      ),
    );
  }
}

class RegisterStudentsTab extends StatelessWidget {
  const RegisterStudentsTab({super.key});
  @override
  Widget build(BuildContext context) => const RegistrationScreen();
}

class MarkAttendanceTab extends StatelessWidget {
  const MarkAttendanceTab({super.key});
  @override
  Widget build(BuildContext context) => const AttendanceScreen();
}

class UploadPdfTab extends StatelessWidget {
  const UploadPdfTab({super.key});
  @override
  Widget build(BuildContext context) => const UploadNotesScreen();
}

class FeesTab extends StatelessWidget {
  const FeesTab({super.key});
  @override
  Widget build(BuildContext context) => const UploadFeesScreen();
}

class RunMigrationTab extends StatelessWidget {
  const RunMigrationTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Text("Migration Screen Coming Soon"),
  );
}