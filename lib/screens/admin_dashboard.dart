// import 'package:flutter/material.dart';
// import 'admin_attendance_screen.dart';
// import 'register_screen.dart'; // your existing registration screen
// // import other screens when you build them
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
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Admin Dashboard",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.redAccent,
//           centerTitle: true,
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(icon: Icon(Icons.person_add), text: "Register Students"),
//               Tab(icon: Icon(Icons.check_circle), text: "Mark Attendance"),
//               Tab(icon: Icon(Icons.picture_as_pdf), text: "Upload PDF"),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             RegisterStudentsTab(),
//             MarkAttendanceTab(),
//             UploadPdfTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// //
// // 👇 Each tab content (you can later replace with full pages)
// //
//
// class RegisterStudentsTab extends StatelessWidget {
//   const RegisterStudentsTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // You can directly reuse your RegistrationScreen here
//     return const RegistrationScreen();
//   }
// }
//
// class MarkAttendanceTab extends StatelessWidget {
//   const MarkAttendanceTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const AdminAttendanceScreen();
//   }
// }
//
// class UploadPdfTab extends StatelessWidget {
//   const UploadPdfTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Upload PDF Screen",
//         style: TextStyle(fontSize: 18, color: Colors.white),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_attendance_screen.dart';
import 'register_screen.dart';
import 'run_migration_screen.dart'; // 👈 Import your migration file

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 👈 Increased from 3 → 4
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            isScrollable: true, // 👈 optional (helps fit 4 tabs)
            tabs: [
              Tab(icon: Icon(Icons.person_add), text: "Register Students"),
              Tab(icon: Icon(Icons.check_circle), text: "Mark Attendance"),
              Tab(icon: Icon(Icons.picture_as_pdf), text: "Upload PDF"),
              Tab(icon: Icon(Icons.sync), text: "Run Migration"), // 👈 new tab
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RegisterStudentsTab(),
            MarkAttendanceTab(),
            UploadPdfTab(),
            RunMigrationTab(), // 👈 added here
          ],
        ),
      ),
    );
  }
}

//
// 👇 Each tab content
//

class RegisterStudentsTab extends StatelessWidget {
  const RegisterStudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegistrationScreen();
  }
}

class MarkAttendanceTab extends StatelessWidget {
  const MarkAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminAttendanceScreen();
  }
}

class UploadPdfTab extends StatelessWidget {
  const UploadPdfTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Upload PDF Screen",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

class RunMigrationTab extends StatelessWidget {
  const RunMigrationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const RunMigrationScreen(); // 👈 directly reuse your migration screen
  }
}
