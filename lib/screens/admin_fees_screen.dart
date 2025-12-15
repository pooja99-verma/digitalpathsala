// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UploadFeesScreen extends StatefulWidget {
//   const UploadFeesScreen({super.key});
//
//   @override
//   State<UploadFeesScreen> createState() => _UploadFeesScreenState();
// }
//
// class _UploadFeesScreenState extends State<UploadFeesScreen> {
//   String selectedClass = '9th';
//   String selectedStream = 'Science';
//   final firestore = FirebaseFirestore.instance;
//
//   final List<String> classes = ['9th', '10th', '11th', '12th'];
//   final List<String> streams = ['Science', 'Commerce'];
//
//   // Controllers for fees
//   final Map<String, TextEditingController> subjectControllers = {};
//   final TextEditingController allSubjectsController = TextEditingController();
//   final TextEditingController monthlyController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }
//
//   void _initializeControllers() {
//     subjectControllers.clear();
//     if (selectedClass == '9th' || selectedClass == '10th') {
//       monthlyController.text = selectedClass == '9th' ? '1200' : '1400';
//     } else if (selectedClass == '11th' || selectedClass == '12th') {
//       if (selectedStream == 'Science') {
//         subjectControllers['Physics'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
//         subjectControllers['Chemistry'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
//         subjectControllers['Biology'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
//         subjectControllers['Maths'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
//         allSubjectsController.text = selectedClass == '11th' ? '2100' : '2400';
//       } else {
//         subjectControllers['Accounts'] = TextEditingController(text: '1000');
//         subjectControllers['Business & Economics'] = TextEditingController(text: selectedClass == '11th' ? '1200' : '1400');
//         allSubjectsController.text = selectedClass == '11th' ? '2000' : '2100';
//       }
//     }
//   }
//
//   Future<void> uploadFees() async {
//     try {
//       if (selectedClass == '9th' || selectedClass == '10th') {
//         await firestore.collection('fees').doc(selectedClass).set({
//           'monthly': int.parse(monthlyController.text),
//         });
//       } else {
//         final subjectsMap = subjectControllers.map((key, controller) => MapEntry(key, int.parse(controller.text)));
//         await firestore
//             .collection('fees')
//             .doc(selectedClass)
//             .collection('streams')
//             .doc(selectedStream)
//             .set({
//           'subjects': subjectsMap,
//           'allSubjects': int.parse(allSubjectsController.text),
//         });
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Fees uploaded successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Upload failed: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Fees')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Select Class"),
//             DropdownButton<String>(
//               value: selectedClass,
//               isExpanded: true,
//               items: classes.map((cls) {
//                 return DropdownMenuItem(value: cls, child: Text(cls));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedClass = value!;
//                   _initializeControllers();
//                 });
//               },
//             ),
//             if (selectedClass == '11th' || selectedClass == '12th') ...[
//               const SizedBox(height: 16),
//               const Text("Select Stream"),
//               DropdownButton<String>(
//                 value: selectedStream,
//                 isExpanded: true,
//                 items: streams.map((stream) {
//                   return DropdownMenuItem(value: stream, child: Text(stream));
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedStream = value!;
//                     _initializeControllers();
//                   });
//                 },
//               ),
//             ],
//             const SizedBox(height: 20),
//             if (selectedClass == '9th' || selectedClass == '10th') ...[
//               TextField(
//                 controller: monthlyController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Monthly Fee"),
//               ),
//             ] else ...[
//               const Text("Subjects Fees"),
//               ...subjectControllers.entries.map((entry) {
//                 return TextField(
//                   controller: entry.value,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(labelText: "${entry.key} Fee"),
//                 );
//               }),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: allSubjectsController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "All Subjects Fee"),
//               ),
//             ],
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: uploadFees,
//               icon: const Icon(Icons.cloud_upload),
//               label: const Text("Update Fees"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//////////////////////////////////.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadFeesScreen extends StatefulWidget {
  const UploadFeesScreen({super.key});

  @override
  State<UploadFeesScreen> createState() => _UploadFeesScreenState();
}

class _UploadFeesScreenState extends State<UploadFeesScreen> {
  String selectedClass = '9th';
  final firestore = FirebaseFirestore.instance;

  final List<String> classes = ['9th', '10th', '11th', '12th'];

  // Controllers for fees
  final Map<String, TextEditingController> subjectControllers = {};
  final TextEditingController allSubjectsController = TextEditingController();
  final TextEditingController monthlyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  // void _initializeControllers() {
  //   subjectControllers.clear();
  //   monthlyController.clear();
  //   allSubjectsController.clear();
  //
  //   if (selectedClass == '9th') {
  //     monthlyController.text = '1200';
  //   } else if (selectedClass == '10th') {
  //     monthlyController.text = '1400';
  //   } else if (selectedClass == '11th' || selectedClass == '12th') {
  //     subjectControllers['Physics'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
  //     subjectControllers['Chemistry'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
  //     subjectControllers['Maths'] = TextEditingController(text: selectedClass == '11th' ? '800' : '900');
  //
  //     allSubjectsController.text = selectedClass == '11th' ? '2100' : '2400';
  //   }
  // }
  void _initializeControllers() {
    subjectControllers.clear();
    monthlyController.clear();
    allSubjectsController.clear();

    if (selectedClass == '9th') {
      monthlyController.text = '1200';
    } else if (selectedClass == '10th') {
      monthlyController.text = '1400';
    } else if (selectedClass == '11th' || selectedClass == '12th') {
      subjectControllers['Physics'] =
          TextEditingController(text: selectedClass == '11th' ? '800' : '900');
      subjectControllers['Chemistry'] =
          TextEditingController(text: selectedClass == '11th' ? '800' : '900');
      subjectControllers['Maths'] =
          TextEditingController(text: selectedClass == '11th' ? '800' : '900');

      // ✅ Add missing subjects for Class 12th
      if (selectedClass == '12th') {
        subjectControllers['Biology'] = TextEditingController(text: '900');
        subjectControllers['Accounts'] = TextEditingController(text: '1000');
        subjectControllers['Business'] = TextEditingController(text: '700');
        subjectControllers['Economics'] = TextEditingController(text: '700');
      }

      allSubjectsController.text =
      selectedClass == '11th' ? '2100' : '2400';
    }
  }


  Future<void> uploadFees() async {
    try {
      if (selectedClass == '9th' || selectedClass == '10th') {
        await firestore.collection('fees').doc(selectedClass).set({
          'monthly': int.parse(monthlyController.text),
        });
      } else {
        final subjectsMap = subjectControllers.map((key, controller) =>
            MapEntry(key, int.parse(controller.text)));

        await firestore.collection('fees').doc(selectedClass).set({
          'subjects': subjectsMap,
          'allSubjects': int.parse(allSubjectsController.text),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Fees uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Fees')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Class"),
            DropdownButton<String>(
              value: selectedClass,
              isExpanded: true,
              items: classes.map((cls) {
                return DropdownMenuItem(value: cls, child: Text(cls));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                  _initializeControllers();
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedClass == '9th' || selectedClass == '10th') ...[
              TextField(
                controller: monthlyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Monthly Fee"),
              ),
            ] else ...[
              const Text("Subjects Fees"),
              ...subjectControllers.entries.map((entry) {
                return TextField(
                  controller: entry.value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "${entry.key} Fee"),
                );
              }),
              const SizedBox(height: 16),
              TextField(
                controller: allSubjectsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "All Subjects Fee"),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: uploadFees,
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Upload Fees"),
            ),
          ],
        ),
      ),
    );
  }
}