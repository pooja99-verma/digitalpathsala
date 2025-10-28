import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  final String className;
  const AttendanceScreen({super.key, required this.className});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map to store attendance for each student (uid -> true/false)
  Map<String, bool> attendanceMap = {};

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Attendance - ${widget.className}",
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.redAccent),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(selectedClass: widget.className),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('classes')
            .doc(widget.className)
            .collection('students')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }

          final students = snapshot.data!.docs;

          // Initialize map if empty
          for (var student in students) {
            if (!attendanceMap.containsKey(student.id)) {
              attendanceMap[student.id] = false; // default Absent
            }
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    bool isPresent = attendanceMap[student.id] ?? false;

                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ListTile(
                        title: Text(
                          student['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Present", style: TextStyle(color: Colors.white70)),
                            Switch(
                              value: isPresent,
                              onChanged: (value) {
                                setState(() {
                                  attendanceMap[student.id] = value;
                                });
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: _isLoading ? null : _saveAttendance,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Save Attendance",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _saveAttendance() async {
    setState(() => _isLoading = true);

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Convert bool map to "Present"/"Absent"
      final attendanceData = attendanceMap.map((key, value) => MapEntry(key, value ? "Present" : "Absent"));

      await _firestore
          .collection('classes')
          .doc(widget.className)
          .collection('attendance')
          .doc(today)
          .set(attendanceData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving attendance: $e")),
      );
    }

    setState(() => _isLoading = false);
  }
}
