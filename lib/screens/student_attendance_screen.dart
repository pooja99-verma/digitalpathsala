import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentAttendanceScreen extends StatelessWidget {
  final String uid;       // Student UID
  final String classId;   // Class the student belongs to

  const StudentAttendanceScreen({super.key, required this.uid, required this.classId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Attendance", style: TextStyle(color: Colors.redAccent)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('classes')
            .doc(classId)
            .collection('attendance')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }

          final attendanceDocs = snapshot.data!.docs;

          if (attendanceDocs.isEmpty) {
            return const Center(
              child: Text("No attendance records found", style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            itemCount: attendanceDocs.length,
            itemBuilder: (context, index) {
              final doc = attendanceDocs[index];
              final date = doc.id;
              final data = doc.data() as Map<String, dynamic>;

              String status = data[uid] ?? "Not Marked";

              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text(
                    "Date: $date",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    status,
                    style: TextStyle(
                      color: status == "Present" ? Colors.green : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
