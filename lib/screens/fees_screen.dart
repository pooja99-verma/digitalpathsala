// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class StudentFeesScreen extends StatelessWidget {
//   final String studentUid;
//
//   const StudentFeesScreen({super.key, required this.studentUid});
//
//   Future<Map<String, dynamic>?> _fetchStudentInfo() async {
//     final doc = await FirebaseFirestore.instance.collection('students').doc(studentUid).get();
//     return doc.data();
//   }
//
//   Future<DocumentSnapshot> _fetchFeeData(String studentClass) async {
//     return await FirebaseFirestore.instance.collection('fees').doc(studentClass).get();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('My Fees', style: TextStyle(color: Colors.redAccent)),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _fetchStudentInfo(),
//         builder: (context, studentSnapshot) {
//           if (studentSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!studentSnapshot.hasData || studentSnapshot.data == null) {
//             return const Center(
//               child: Text('Student data not found',
//                   style: TextStyle(color: Colors.white70, fontSize: 18)),
//             );
//           }
//
//           final studentData = studentSnapshot.data!;
//           final studentClass = studentData['CLASS'] ?? '';
//
//           if (studentClass.isEmpty) {
//             return const Center(
//               child: Text('Class info missing',
//                   style: TextStyle(color: Colors.white70, fontSize: 18)),
//             );
//           }
//
//           return FutureBuilder<DocumentSnapshot>(
//             future: _fetchFeeData(studentClass),
//             builder: (context, feeSnapshot) {
//               if (feeSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (!feeSnapshot.hasData || feeSnapshot.data == null || feeSnapshot.data!.data() == null) {
//                 return Center(
//                   child: Text('No fee details available for $studentClass',
//                       style: const TextStyle(color: Colors.white70, fontSize: 18)),
//                 );
//               }
//
//               final data = feeSnapshot.data!.data() as Map<String, dynamic>;
//
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Class: $studentClass",
//                         style: const TextStyle(color: Colors.white, fontSize: 18)),
//                     const SizedBox(height: 20),
//                     if (data.containsKey('monthly')) ...[
//                       Text("Monthly Fee: ₹${data['monthly']}",
//                           style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
//                     ],
//                     if (data.containsKey('subjects')) ...[
//                       const Text("Subject-wise Fees:",
//                           style: TextStyle(
//                               color: Colors.redAccent,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 10),
//                       ...Map<String, dynamic>.from(data['subjects']).entries.map((entry) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: Text("${entry.key}: ₹${entry.value}",
//                             style: const TextStyle(color: Colors.white, fontSize: 16)),
//                       )),
//                     ],
//                     if (data.containsKey('allSubjects')) ...[
//                       const SizedBox(height: 20),
//                       Text("Total: ₹${data['allSubjects']}",
//                           style: const TextStyle(
//                               color: Colors.greenAccent,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),
//                     ],
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

///////////////////
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
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        title: const Text(
          'My Fees',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
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
                  style: TextStyle(color: Colors.black54, fontSize: 16)),
            );
          }

          final studentData = studentSnapshot.data!;
          final studentClass = studentData['CLASS'] ?? '';

          if (studentClass.isEmpty) {
            return const Center(
              child: Text('Class info missing',
                  style: TextStyle(color: Colors.black54, fontSize: 16)),
            );
          }

          return FutureBuilder<DocumentSnapshot>(
            future: _fetchFeeData(studentClass),
            builder: (context, feeSnapshot) {
              if (feeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!feeSnapshot.hasData ||
                  feeSnapshot.data == null ||
                  feeSnapshot.data!.data() == null) {
                return Center(
                  child: Text(
                    'No fee details available for $studentClass',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                );
              }

              final data = feeSnapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoCard("Class", studentClass, Colors.deepPurpleAccent.shade100),
                    const SizedBox(height: 20),

                    if (data.containsKey('monthly'))
                      _infoCard("Monthly Fee", "₹${data['monthly']}",
                          Colors.greenAccent.shade100),

                    if (data.containsKey('subjects')) ...[
                      const SizedBox(height: 25),
                      const Text(
                        "Subject-wise Fees",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...Map<String, dynamic>.from(data['subjects'])
                          .entries
                          .map((entry) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(entry.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500)),
                          trailing: Text(
                            "₹${entry.value}",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),
                    ],

                    if (data.containsKey('allSubjects')) ...[
                      const SizedBox(height: 25),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade100,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            "Total Fee: ₹${data['allSubjects']}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
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

  Widget _infoCard(String title, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: bgColor, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}
