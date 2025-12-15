// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class StudentAttendanceScreen extends StatefulWidget {
//   final String studentUid;
//
//   const StudentAttendanceScreen({super.key, required this.studentUid});
//
//   @override
//   State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
// }
//
// class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
//   final firestore = FirebaseFirestore.instance;
//   DateTime selectedDate = DateTime.now();
//   String? attendanceStatus;
//   List<String> subjects = [];
//   String selectedSubject = '';
//
//   Future<void> fetchStudentData(DateTime date) async {
//     final doc = await firestore.collection('students').doc(widget.studentUid).get();
//     final data = doc.data();
//
//     if (data != null) {
//       final attendanceList = List<Map<String, dynamic>>.from(data['attendance'] ?? []);
//       final subjectList = List<String>.from(data['SUBJECTS'] ?? []);
//       final formattedDate = DateFormat('yyyy-MM-dd').format(date);
//
//       String? statusForSubject;
//
//       for (var entry in attendanceList) {
//         if (entry['date'] == formattedDate &&
//             (selectedSubject.isEmpty || entry['subject'] == selectedSubject)) {
//           statusForSubject = entry['status'];
//           break;
//         }
//       }
//
//       setState(() {
//         attendanceStatus = statusForSubject ?? 'Not marked';
//         subjects = subjectList;
//       });
//     } else {
//       setState(() {
//         attendanceStatus = 'No data';
//         subjects = [];
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStudentData(selectedDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("My Attendance", style: TextStyle(color: Colors.redAccent)),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: selectedDate,
//                   firstDate: DateTime(2025, 1),
//                   lastDate: DateTime.now(),
//                   builder: (context, child) {
//                     return Theme(data: ThemeData.dark(), child: child!);
//                   },
//                 );
//
//                 if (picked != null) {
//                   setState(() {
//                     selectedDate = picked;
//                   });
//                   await fetchStudentData(picked);
//                 }
//               },
//               icon: const Icon(Icons.calendar_today),
//               label: const Text("Select Date"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             ),
//             const SizedBox(height: 20),
//             Text("Date: $formattedDate", style: const TextStyle(color: Colors.white, fontSize: 18)),
//             const SizedBox(height: 20),
//             const Text("Subjects:", style: TextStyle(color: Colors.white, fontSize: 18)),
//             const SizedBox(height: 10),
//             subjects.isNotEmpty
//                 ? Wrap(
//               spacing: 10,
//               children: subjects.map((subject) {
//                 final isSelected = subject == selectedSubject;
//                 return ElevatedButton(
//                   onPressed: () async {
//                     setState(() {
//                       selectedSubject = subject;
//                     });
//                     await fetchStudentData(selectedDate);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isSelected ? Colors.redAccent : Colors.grey[800],
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text(subject),
//                 );
//               }).toList(),
//             )
//                 : const Text("No subjects found", style: TextStyle(color: Colors.white70)),
//             const SizedBox(height: 30),
//             if (selectedSubject.isNotEmpty)
//               Text(
//                 "Selected Subject: $selectedSubject",
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             const SizedBox(height: 10),
//             if (selectedSubject.isNotEmpty)
//               Text(
//                 "Status: ${attendanceStatus ?? 'Loading...'}",
//                 style: TextStyle(
//                   color: attendanceStatus == 'Present'
//                       ? Colors.greenAccent
//                       : attendanceStatus == 'Absent'
//                       ? Colors.redAccent
//                       : Colors.white70,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///////////////////////////

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final String studentUid;

  const StudentAttendanceScreen({super.key, required this.studentUid});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  String? attendanceStatus;
  List<String> subjects = [];
  String selectedSubject = '';

  Future<void> fetchStudentData(DateTime date) async {
    final doc =
    await firestore.collection('students').doc(widget.studentUid).get();
    final data = doc.data();

    if (data != null) {
      final attendanceList =
      List<Map<String, dynamic>>.from(data['attendance'] ?? []);
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: const Text(
          "My Attendance",
          style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9FAFB), Color(0xFFEDEDED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: size.width * 0.07, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📅 Date Picker Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2025, 1),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.redAccent,
                              ),
                            ),
                            child: child!);
                      },
                    );

                    if (picked != null) {
                      setState(() => selectedDate = picked);
                      await fetchStudentData(picked);
                    }
                  },
                  icon: const Icon(Icons.calendar_month_outlined,
                      color: Colors.white),
                  label: const Text(
                    "Select Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 📆 Date Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.today, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Text(
                    "Date: $formattedDate",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 📘 Subjects Section
              const Text(
                "Subjects",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              subjects.isNotEmpty
                  ? Wrap(
                spacing: 10,
                runSpacing: 10,
                children: subjects.map((subject) {
                  final isSelected = subject == selectedSubject;
                  return ChoiceChip(
                    label: Text(
                      subject,
                      style: TextStyle(
                          color:
                          isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.redAccent,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (_) async {
                      setState(() => selectedSubject = subject);
                      await fetchStudentData(selectedDate);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  );
                }).toList(),
              )
                  : const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "No subjects found.",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              // 🎯 Attendance Summary Card
              if (selectedSubject.isNotEmpty)
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_outlined,
                                color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Text(
                              selectedSubject,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              attendanceStatus == 'Present'
                                  ? Icons.check_circle_outline
                                  : attendanceStatus == 'Absent'
                                  ? Icons.cancel_outlined
                                  : Icons.help_outline,
                              color: attendanceStatus == 'Present'
                                  ? Colors.green
                                  : attendanceStatus == 'Absent'
                                  ? Colors.redAccent
                                  : Colors.grey,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Status: ${attendanceStatus ?? 'Loading...'}",
                              style: TextStyle(
                                color: attendanceStatus == 'Present'
                                    ? Colors.green
                                    : attendanceStatus == 'Absent'
                                    ? Colors.redAccent
                                    : Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
