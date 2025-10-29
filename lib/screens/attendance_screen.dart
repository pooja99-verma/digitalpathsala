// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceScreen extends StatefulWidget {
//   final String className;
//   const AttendanceScreen({super.key, required this.className});
//
//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }
//
// class _AttendanceScreenState extends State<AttendanceScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Map<studentId, bool> for attendance
//   Map<String, bool> attendanceMap = {};
//   bool _isSaving = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           "Mark Attendance - ${widget.className}",
//           style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('classes')
//             .doc(widget.className)
//             .collection('students')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.redAccent),
//             );
//           }
//
//           final students = snapshot.data!.docs;
//
//           if (students.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No students found in this class.",
//                 style: TextStyle(color: Colors.white70),
//               ),
//             );
//           }
//
//           // initialize map if empty
//           for (var s in students) {
//             attendanceMap.putIfAbsent(s.id, () => false);
//           }
//
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: students.length,
//                   itemBuilder: (context, index) {
//                     var student = students[index];
//                     bool isPresent = attendanceMap[student.id] ?? false;
//
//                     return Card(
//                       color: Colors.grey[900],
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                       child: ListTile(
//                         title: Text(
//                           student['name'],
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         trailing: Switch(
//                           value: isPresent,
//                           onChanged: (v) {
//                             setState(() {
//                               attendanceMap[student.id] = v;
//                             });
//                           },
//                           activeColor: Colors.green,
//                           inactiveThumbColor: Colors.red,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   onPressed: _isSaving ? null : _saveAttendance,
//                   child: _isSaving
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                     "Save Attendance",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _saveAttendance() async {
//     setState(() => _isSaving = true);
//
//     try {
//       final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//       // convert to "Present"/"Absent"
//       final formattedData = attendanceMap.map((k, v) => MapEntry(k, v ? "Present" : "Absent"));
//
//       await _firestore
//           .collection('classes')
//           .doc(widget.className)
//           .collection('attendance')
//           .doc(today)
//           .set(formattedData);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("✅ Attendance saved successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Error saving attendance: $e")),
//       );
//     }
//
//     setState(() => _isSaving = false);
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  final String className;
  const AttendanceScreen({super.key, required this.className});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final firestore = FirebaseFirestore.instance;
  final Map<String, bool> attendance = {}; // uid -> present/absent

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Mark Attendance - ${widget.className}",
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.redAccent),
            onPressed: () async {
              await _saveAttendance(today);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Attendance saved to Firestore")),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore
            .collection('users')
            .where('classId', isEqualTo: widget.className)
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
              child: Text(
                "No students found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final uid = student.id;
              final name = student['name'];
              final isPresent = attendance[uid] ?? false;

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(name, style: const TextStyle(color: Colors.white)),
                  trailing: Switch(
                    value: isPresent,
                    activeColor: Colors.greenAccent,
                    onChanged: (value) {
                      setState(() {
                        attendance[uid] = value;
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _saveAttendance(String date) async {
    final batch = firestore.batch();

    attendance.forEach((uid, present) {
      final userRef = firestore.collection('users').doc(uid);
      batch.update(userRef, {
        'attendance.$date': present,
      });
    });

    await batch.commit();
  }
}
