import 'package:digital_pathsala/screens/studentsscreens/payment_scanner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../admin_fees_screen.dart';
import '../attendance_screen.dart';
import '../fees_screen.dart';
import '../notes_screen.dart';
import '../role_selection_screen.dart';

class StudentDashboardScreen extends StatelessWidget {
  final String className;

  const StudentDashboardScreen({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final studentName = user?.email?.split('@').first ?? 'Student';
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.20;
    final cardWidth = size.width * 0.40;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Student Dashboard",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.redAccent.shade100,
              backgroundImage: const AssetImage('assets/dpprofile.png'),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F9FA), Color(0xFFEFEFEF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.04, // 🔹 reduced from 0.07
            ),
            child: Column(
              children: [
                const SizedBox(height: 10), // 🔹 spacing below AppBar

                CircleAvatar(
                  radius: size.width * 0.18,
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  backgroundImage: const AssetImage('assets/dpprofile.png'),
                ),

                const SizedBox(height: 12),

                Text(
                  "Welcome, $studentName 👋",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: cardWidth / cardHeight,
                    children: [
                      _buildCard(
                        context,
                        title: "Attendance",
                        icon: Icons.check_circle_outline,
                        color: Colors.greenAccent.shade100,
                        screen: StudentAttendanceScreen(
                          studentUid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                      _buildCard(
                        context,
                        title: "Notes",
                        icon: Icons.menu_book_rounded,
                        color: Colors.blueAccent.shade100,
                        screen: StudentNotesScreen(
                          studentUid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                      _buildCard(
                        context,
                        title: "Fees",
                        icon: Icons.account_balance_wallet_outlined,
                        color: Colors.amberAccent.shade100,
                        screen: StudentFeesScreen(
                          studentUid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                      _buildCard(
                        context,
                        title: "Payment",
                        icon: Icons.qr_code_scanner,
                        color: Colors.purpleAccent.shade100,
                        screen: const PaymentScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Widget screen,
        required Color color,
      }) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.redAccent, size: size.width * 0.12),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

