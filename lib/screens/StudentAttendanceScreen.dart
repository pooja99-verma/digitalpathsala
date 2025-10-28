import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Attendance"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .where('studentId', isEqualTo: currentUser!.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final records = snapshot.data!.docs;
          if (records.isEmpty) return const Center(child: Text("No attendance records found"));

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final data = records[index].data() as Map<String, dynamic>;
              final date = (data['date'] as Timestamp).toDate();
              final status = data['status'];

              return ListTile(
                title: Text("${date.day}/${date.month}/${date.year}"),
                trailing: Text(status,
                    style: TextStyle(
                        color: status == 'Present' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold)),
              );
            },
          );
        },
      ),
    );
  }
}
