import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final String selectedClass; // Pass the class teacher wants to mark attendance for

  const TeacherAttendanceScreen({super.key, required this.selectedClass});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  Map<String, bool> attendanceMap = {}; // studentId -> isPresent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance - ${widget.selectedClass}"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('class', isEqualTo: widget.selectedClass)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final students = snapshot.data!.docs;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index].data() as Map<String, dynamic>;
              final studentId = students[index].id;
              final studentName = student['name'];

              attendanceMap.putIfAbsent(studentId, () => true); // default present

              return ListTile(
                title: Text(studentName),
                trailing: Switch(
                  value: attendanceMap[studentId]!,
                  onChanged: (val) {
                    setState(() {
                      attendanceMap[studentId] = val;
                    });
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            for (var entry in attendanceMap.entries) {
              await FirebaseFirestore.instance.collection('attendance').add({
                'studentId': entry.key,
                'class': widget.selectedClass,
                'date': FieldValue.serverTimestamp(),
                'status': entry.value ? 'Present' : 'Absent',
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Attendance marked successfully!")));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("Submit Attendance", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
