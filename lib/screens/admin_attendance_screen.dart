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
        title: const Text("Attendance Saved"),
        content: Text(
          "Class: $selectedClass\n"
              "${(selectedClass == '11th' || selectedClass == '12th') ? "Subject: $selectedSubject\n" : ""}"
              "\nTotal: ${attendance.length}\nPresent: $totalPresent\nAbsent: $totalAbsent",
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Class Dropdown ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedClass,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  // items: ['9', '10', '11th', '12th'].map((classValue)
                    items: ['9', '10', '11th', '12th', 'Competitive Exam'].map((classValue) {
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
              ),

              SizedBox(height: screenHeight * 0.02),

              // --- Subject Buttons for 11th & 12th ---
              if (selectedClass == '11th' || selectedClass == '12th') ...[
                const Text("Select Subject",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: screenHeight * 0.01),
                Wrap(
                  spacing: 10,
                  children: [
                    'Physics',
                    'Chemistry',
                    'Biology',
                    'Accounts',
                    'Economics',
                    'Maths'
                  ].map((subject) {
                    final isSelected = selectedSubject == subject;
                    return ChoiceChip(
                      label: Text(subject),
                      selected: isSelected,
                      selectedColor: Colors.redAccent.shade100,
                      onSelected: (_) {
                        setState(() {
                          selectedSubject = subject;
                          showStudents = true;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],

              // --- Student List ---
              Expanded(
                child: showStudents
                    ? FutureBuilder<QuerySnapshot>(
                  future: (selectedClass == '11th' ||
                      selectedClass == '12th')
                      ? firestore
                      .collection('students')
                      .where('CLASS', isEqualTo: selectedClass)
                      .where('SUBJECTS',
                      arrayContains: selectedSubject)
                      .get()
                      : firestore
                      .collection('students')
                      .where('CLASS', isEqualTo: selectedClass)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final students = snapshot.data!.docs;
                    if (students.isEmpty) {
                      return const Center(
                        child: Text(
                          "No students found",
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding:
                      EdgeInsets.only(bottom: screenHeight * 0.08),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final uid = student.id;
                        final name = student['NAME'];
                        final isPresent = attendance[uid];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  const AssetImage('assets/dpprofile.png'),
                                  radius: screenWidth * 0.06,
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isPresent == true
                                            ? Colors.green
                                            : Colors.grey[300],
                                        foregroundColor: isPresent == true
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          attendance[uid] = true;
                                        });
                                      },
                                      child: const Text("Present"),
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isPresent == false
                                            ? Colors.redAccent
                                            : Colors.grey[300],
                                        foregroundColor: isPresent == false
                                            ? Colors.white
                                            : Colors.black,
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
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                    : const Center(
                  child: Text(
                    "Select class and subject to view students",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              // --- Save Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (attendance.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("No students to save attendance")),
                      );
                      return;
                    }
                    await _saveAttendance(today);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Attendance saved successfully")),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Attendance",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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




