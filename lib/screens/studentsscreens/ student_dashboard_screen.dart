
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../admin_fees_screen.dart';
import '../attendance_screen.dart';
import '../fees_screen.dart';
import '../notes_screen.dart';
import '../role_selection_screen.dart'; // Make sure this exists

class StudentDashboardScreen extends StatelessWidget {
  final String className;

  const StudentDashboardScreen({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final studentName = user?.email?.split('@').first ?? 'Student';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Student Dashboard",
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                        (route) => false,
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Welcome, $studentName",
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildCard(
                    context,
                    title: "Attendance",
                    icon: Icons.check_circle,
                    screen: StudentAttendanceScreen(studentUid: FirebaseAuth.instance.currentUser!.uid),
                  ),
                  _buildCard(
                    context,
                    title: "Notes",
                    icon: Icons.book,
                   // screen: StudentNotesScreen(studentUid: FirebaseAuth.instance.currentUser!.uid,),
                    screen: StudentNotesScreen(studentUid: FirebaseAuth.instance.currentUser!.uid),
                  ),
              _buildCard(
                context,
                title: "Fee Structure",
                icon: Icons.money,
                screen: StudentFeesScreen(studentUid: FirebaseAuth.instance.currentUser!.uid),
              ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required IconData icon, required Widget screen}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.redAccent, size: 50),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}