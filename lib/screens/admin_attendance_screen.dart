import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final firestore = FirebaseFirestore.instance;
  final Map<String, bool> attendance = {};
  bool showStudents = false;
  String selectedClass = '9';
  String selectedSubject = '';

  int totalPresent = 0;
  int totalAbsent = 0;

  Future<void> _saveAttendance(String date) async {
    final batch = firestore.batch();

    totalPresent = 0;
    totalAbsent = 0;

    attendance.forEach((uid, present) {
      final studentRef = firestore.collection('students').doc(uid);
      final attendanceRecord = {
        'date': date,
        'status': present ? 'Present' : 'Absent',
      };

      // Add subject only for 11th and 12th
      if (selectedClass == '11th' || selectedClass == '12th') {
        attendanceRecord['subject'] = selectedSubject;
      }

      batch.update(studentRef, {
        'attendance': FieldValue.arrayUnion([attendanceRecord])
      });

      if (present) {
        totalPresent++;
      } else {
        totalAbsent++;
      }
    });

    await batch.commit();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Attendance Summary"),
        content: Text(
          "✅ Saved for Class $selectedClass\n"
              "${(selectedClass == '11th' || selectedClass == '12th') ? "Subject: $selectedSubject\n" : ""}"
              "\nTotal Students: ${attendance.length}\n"
              "Present: $totalPresent\n"
              "Absent: $totalAbsent",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: showStudents
          ? FutureBuilder<QuerySnapshot>(
        future: (selectedClass == '11th' || selectedClass == '12th')
            ? firestore
            .collection('students')
            .where('CLASS', isEqualTo: selectedClass)
            .where('SUBJECTS', arrayContains: selectedSubject)
            .get()
            : firestore
            .collection('students')
            .where('CLASS', isEqualTo: selectedClass)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          final students = snapshot.data!.docs;
          if (students.isEmpty) {
            return const Center(
              child: Text("No students found", style: TextStyle(color: Colors.white70)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final uid = student.id;
                    final name = student['NAME'];
                    final isPresent = attendance[uid];

                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(name, style: const TextStyle(color: Colors.white)),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPresent == true
                                    ? Colors.green
                                    : Colors.grey[800],
                              ),
                              onPressed: () {
                                setState(() {
                                  attendance[uid] = true;
                                });
                              },
                              child: const Text("Present"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPresent == false
                                    ? Colors.red
                                    : Colors.grey[800],
                              ),
                              onPressed: () {
                                setState(() {
                                  attendance[uid] = false;
                                });
                              },
                              child: const Text("Absent"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _saveAttendance(today);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Attendance saved to Firestore")),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Attendance"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedClass,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white, fontSize: 18),
              items: ['9', '10', '11th', '12th'].map((classValue) {
                return DropdownMenuItem<String>(
                  value: classValue,
                  child: Text('Class $classValue'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                  selectedSubject = '';
                  showStudents = selectedClass == '9' || selectedClass == '10';
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedClass == '11th' || selectedClass == '12th') ...[
              const Text("Select Subject",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Wrap(
                spacing: 10,
                children: [
                  'Physics',
                  'Chemistry',
                  'Biology',
                  'Accounts',
                  'Economics',
                  'Maths'
                ].map((subject) => ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedSubject = subject;
                      showStudents = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(subject),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}