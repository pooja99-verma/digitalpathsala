import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFeesScreen extends StatelessWidget {
  final String studentUid;

  const StudentFeesScreen({super.key, required this.studentUid});

  Future<Map<String, dynamic>?> _fetchStudentInfo() async {
    final doc = await FirebaseFirestore.instance.collection('students').doc(studentUid).get();
    return doc.data();
  }

  Future<DocumentSnapshot> _fetchFeeData(String studentClass) async {
    return await FirebaseFirestore.instance.collection('fees').doc(studentClass).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Fees', style: TextStyle(color: Colors.redAccent)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchStudentInfo(),
        builder: (context, studentSnapshot) {
          if (studentSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!studentSnapshot.hasData || studentSnapshot.data == null) {
            return const Center(
              child: Text('Student data not found',
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
            );
          }

          final studentData = studentSnapshot.data!;
          final studentClass = studentData['CLASS'] ?? '';

          if (studentClass.isEmpty) {
            return const Center(
              child: Text('Class info missing',
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
            );
          }

          return FutureBuilder<DocumentSnapshot>(
            future: _fetchFeeData(studentClass),
            builder: (context, feeSnapshot) {
              if (feeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!feeSnapshot.hasData || feeSnapshot.data == null || feeSnapshot.data!.data() == null) {
                return Center(
                  child: Text('No fee details available for $studentClass',
                      style: const TextStyle(color: Colors.white70, fontSize: 18)),
                );
              }

              final data = feeSnapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Class: $studentClass",
                        style: const TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 20),
                    if (data.containsKey('monthly')) ...[
                      Text("Monthly Fee: ₹${data['monthly']}",
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
                    ],
                    if (data.containsKey('subjects')) ...[
                      const Text("Subject-wise Fees:",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...Map<String, dynamic>.from(data['subjects']).entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text("${entry.key}: ₹${entry.value}",
                            style: const TextStyle(color: Colors.white, fontSize: 16)),
                      )),
                    ],
                    if (data.containsKey('allSubjects')) ...[
                      const SizedBox(height: 20),
                      Text("Total: ₹${data['allSubjects']}",
                          style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}