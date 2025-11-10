import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final String studentUid;

  const StudentAttendanceScreen({super.key, required this.studentUid});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  String? attendanceStatus;
  List<String> subjects = [];
  String selectedSubject = '';

  Future<void> fetchStudentData(DateTime date) async {
    final doc = await firestore.collection('students').doc(widget.studentUid).get();
    final data = doc.data();

    if (data != null) {
      final attendanceList = List<Map<String, dynamic>>.from(data['attendance'] ?? []);
      final subjectList = List<String>.from(data['SUBJECTS'] ?? []);
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      String? statusForSubject;

      for (var entry in attendanceList) {
        if (entry['date'] == formattedDate &&
            (selectedSubject.isEmpty || entry['subject'] == selectedSubject)) {
          statusForSubject = entry['status'];
          break;
        }
      }

      setState(() {
        attendanceStatus = statusForSubject ?? 'Not marked';
        subjects = subjectList;
      });
    } else {
      setState(() {
        attendanceStatus = 'No data';
        subjects = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudentData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Attendance", style: TextStyle(color: Colors.redAccent)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2025, 1),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(data: ThemeData.dark(), child: child!);
                  },
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                  await fetchStudentData(picked);
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text("Select Date"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
            const SizedBox(height: 20),
            Text("Date: $formattedDate", style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Subjects:", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            subjects.isNotEmpty
                ? Wrap(
              spacing: 10,
              children: subjects.map((subject) {
                final isSelected = subject == selectedSubject;
                return ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      selectedSubject = subject;
                    });
                    await fetchStudentData(selectedDate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.redAccent : Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(subject),
                );
              }).toList(),
            )
                : const Text("No subjects found", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),
            if (selectedSubject.isNotEmpty)
              Text(
                "Selected Subject: $selectedSubject",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            const SizedBox(height: 10),
            if (selectedSubject.isNotEmpty)
              Text(
                "Status: ${attendanceStatus ?? 'Loading...'}",
                style: TextStyle(
                  color: attendanceStatus == 'Present'
                      ? Colors.greenAccent
                      : attendanceStatus == 'Absent'
                      ? Colors.redAccent
                      : Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}