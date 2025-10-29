import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'attendance_screen.dart';
import 'notes_screen.dart';
import 'fees_screen.dart';

class HomeScreen extends StatelessWidget {
  final String selectedClass;
  const HomeScreen({super.key, required this.selectedClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Home - $selectedClass",
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Profile icon with menu
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (value == 'about') {
                showAboutDialog(
                  context: context,
                  applicationName: 'Digital पाठशाला',
                  applicationVersion: '1.0',
                  applicationIcon: const Icon(Icons.school, size: 40, color: Colors.redAccent),
                  children: const [
                    Text("This is a demo educational app."),
                  ],
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'about', child: Text('About')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome to DIGITAL पाठशाला",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Select what you want to access",
              style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    color: Colors.redAccent,
                    screen: AttendanceScreen(className: selectedClass),
                  ),
                  _buildCard(
                    context,
                    title: "Notes",
                    icon: Icons.book,
                    color: Colors.redAccent,
                    screen: NotesScreen(className: selectedClass),
                  ),
                  _buildCard(
                    context,
                    title: "Fees",
                    icon: Icons.money,
                    color: Colors.redAccent,
                    screen: FeesScreen(className: selectedClass),
                  ),
                  _buildCard(
                    context,
                    title: "Profile",
                    icon: Icons.person,
                    color: Colors.redAccent,
                    screen: null, // You can add profile screen later
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
      {required String title,
        required IconData icon,
        required Color color,
        Widget? screen}) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        }
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
            Icon(icon, color: color, size: 50),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
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
