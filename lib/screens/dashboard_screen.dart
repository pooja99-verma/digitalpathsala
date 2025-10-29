import 'package:flutter/material.dart';
import 'attendance_screen.dart';
import 'home_screen.dart';
import 'notes_screen.dart';
import 'fees_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String selectedClass;
  const DashboardScreen({super.key, required this.selectedClass});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(selectedClass: widget.selectedClass),
      AttendanceScreen(className: widget.selectedClass),
      NotesScreen(className: widget.selectedClass),
      FeesScreen(className: widget.selectedClass),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Fees'),
        ],
      ),
    );
  }
}
