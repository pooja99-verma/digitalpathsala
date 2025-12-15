// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class UploadNotesScreen extends StatefulWidget {
//   const UploadNotesScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UploadNotesScreen> createState() => _UploadNotesScreenState();
// }
//
// class _UploadNotesScreenState extends State<UploadNotesScreen> {
//   String selectedClass = '9th';
//   String selectedSubject = 'Science';
//   File? selectedPdf;
//   bool isUploading = false;
//   String statusMessage = '';
//
//   final _chapterController = TextEditingController();
//
//   final List<String> classes = ['9th', '10th', '11th', '12th'];
//   final Map<String, List<String>> subjectsByClass = {
//     '9th': ['Science', 'Math'],
//     '10th': ['Science', 'Math'],
//     '11th': ['Physics', 'Biology', 'Math', 'Chemistry', 'Economics', 'Accounts'],
//     '12th': ['Physics', 'Biology', 'Math', 'Chemistry', 'Economics', 'Accounts'],
//   };
//
//   Future<void> pickPdfFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (!mounted) return;
//
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         selectedPdf = File(result.files.single.path!);
//         statusMessage = '✅ PDF selected: ${result.files.single.name}';
//       });
//     } else {
//       setState(() {
//         statusMessage = '⚠️ No file selected';
//       });
//     }
//   }
//
//   Future<void> uploadPdfNote() async {
//     final chapterName = _chapterController.text.trim();
//     if (selectedPdf == null || chapterName.isEmpty) {
//       setState(() {
//         statusMessage = '⚠️ Please select a PDF and enter chapter name';
//       });
//       return;
//     }
//
//     setState(() {
//       isUploading = true;
//       statusMessage = 'Uploading...';
//     });
//
//     try {
//       // Build correct path (verify path values avoid illegal chars)
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('notes/$selectedClass/$selectedSubject/$chapterName.pdf');
//
//       // Upload and wait until complete
//       UploadTask uploadTask = storageRef.putFile(selectedPdf!);
//
//       TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
//       final pdfUrl = await snapshot.ref.getDownloadURL();
//
//       // Save metadata in Firestore
//       await FirebaseFirestore.instance
//           .collection('notes')
//           .doc(selectedClass)
//           .collection('subjects')
//           .doc(selectedSubject)
//           .collection('chapters')
//           .doc(chapterName)
//           .set({
//         'pdfUrl': pdfUrl,
//         'uploadedAt': FieldValue.serverTimestamp(),
//       });
//
//       setState(() {
//         statusMessage = '✅ PDF uploaded successfully!';
//         _chapterController.clear();
//         selectedPdf = null;
//       });
//     } on FirebaseException catch (e) {
//       setState(() {
//         statusMessage = '❌ Upload failed: ${e.message}';
//       });
//     } catch (e) {
//       setState(() {
//         statusMessage = '❌ Unexpected error: $e';
//       });
//     }
//
//     setState(() {
//       isUploading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final subjects = subjectsByClass[selectedClass]!;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Notes')),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.05,
//           vertical: screenHeight * 0.02,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Class", style: TextStyle(fontSize: screenWidth * 0.045)),
//             DropdownButton<String>(
//               value: selectedClass,
//               isExpanded: true,
//               items: classes.map((cls) =>
//                   DropdownMenuItem(value: cls, child: Text(cls))
//               ).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedClass = value!;
//                   selectedSubject = subjectsByClass[selectedClass]!.first;
//                 });
//               },
//             ),
//             SizedBox(height: screenHeight * 0.02),
//
//             Text("Select Subject", style: TextStyle(fontSize: screenWidth * 0.045)),
//             DropdownButton<String>(
//               value: selectedSubject,
//               isExpanded: true,
//               items: subjects.map((subj) =>
//                   DropdownMenuItem(value: subj, child: Text(subj))
//               ).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedSubject = value!;
//                 });
//               },
//             ),
//             SizedBox(height: screenHeight * 0.02),
//
//             Text("Chapter Name", style: TextStyle(fontSize: screenWidth * 0.045)),
//             TextField(
//               controller: _chapterController,
//               decoration: const InputDecoration(
//                 hintText: "Enter Chapter Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.03),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: pickPdfFile,
//                 icon: const Icon(Icons.attach_file),
//                 label: const Text("Pick PDF"),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: isUploading ? null : uploadPdfNote,
//                 icon: const Icon(Icons.cloud_upload),
//                 label: const Text("Upload PDF"),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//
//             if (isUploading) const Center(child: CircularProgressIndicator()),
//
//             Text(statusMessage, style: TextStyle(fontSize: screenWidth * 0.04)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadNotesScreen extends StatefulWidget {
  const UploadNotesScreen({super.key});

  @override
  State<UploadNotesScreen> createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  String selectedClass = '9th';
  String selectedSubject = 'Science';
  String? selectedChapter;
  bool isSaving = false;
  String statusMessage = '';

  final _chapterController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> classes = ['9th', '10th', '11th', '12th'];

  final Map<String, List<String>> subjectsByClass = const {
    '9th': ['Science', 'Math'],
    '10th': ['Science', 'Math'],
    '11th': [
      'Physics',
      'Biology',
      'Math',
      'Chemistry',
      'Economics',
      'Accounts'
    ],
    '12th': [
      'Physics',
      'Biology',
      'Math',
      'Chemistry',
      'Economics',
      'Accounts'
    ],
  };

  final List<String> accountsChapters = const [
    'Meaning and Objectives of Accounting',
    'Basic Accounting Terms',
    'Accounting Principles',
    'Process and Bases of Accounting',
    'Accounting Standards',
    'Accounting Equations',
    'Double Entry System',
    'Origin of Transactions: Source Documents of Accountancy',
    'Books of Original Entry — Journal',
    'Accounting for Goods & Service Tax (GST)',
    'Books of Original Entry — Cash Book',
    'Books of Original Entry — Special Purpose Subsidiary Books',
    'Ledger',
    'Trial Balance and Errors',
    'Bank Reconciliation Statement',
    'Depreciation',
    'Provisions and Reserves',
    'Bills of Exchange',
    'Rectification of Errors',
    'Capital and Revenue',
    'Financial Statements',
    'Financial Statements — With Adjustments',
    'Accounts from Incomplete Records',
    'Introduction to Computers',
    'Introduction to Accounting Information System',
    'Computerised Accounting System',
    'Accounting Software Package: Tally'
  ];

  /// Saves both chapter and notes content (min 300 chars)
  Future<void> saveChapterWithNotes() async {
    final String? chapterName = (selectedClass == '12th' &&
        selectedSubject == 'Accounts')
        ? selectedChapter
        : _chapterController.text.trim();

    final String notesText = _notesController.text.trim();

    if (chapterName == null || chapterName.isEmpty) {
      setState(() {
        statusMessage = '⚠️ Please enter/select a chapter name';
      });
      return;
    }

    if (notesText.isEmpty || notesText.length < 300) {
      setState(() {
        statusMessage =
        '⚠️ Notes must be at least 300 characters. Current: ${notesText
            .length}';
      });
      return;
    }

    setState(() {
      isSaving = true;
      statusMessage = 'Saving...';
    });

    try {
      final chapterRef = FirebaseFirestore.instance
          .collection('notes')
          .doc(selectedClass)
          .collection('subjects')
          .doc(selectedSubject)
          .collection('chapters')
          .doc(chapterName);

      // Save/merge chapter fields
      await chapterRef.set({
        'chapterName': chapterName,
        'uploadedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Save notes in the same doc. If you prefer separate subcollection, see alternative below.
      await chapterRef.set({
        'notesContent': notesText,
        'notesLength': notesText.length,
        'notesUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        statusMessage = '✅ Chapter & notes saved successfully!';
        _chapterController.clear();
        _notesController.clear();
        selectedChapter = null;
      });
    } catch (e) {
      setState(() {
        statusMessage = '❌ Save failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _chapterController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = subjectsByClass[selectedClass]!;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Chapter & Notes')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Class
            Text("Select Class",
                style: TextStyle(fontSize: screenWidth * 0.045)),
            DropdownButton<String>(
              value: selectedClass,
              isExpanded: true,
              items: classes
                  .map((cls) => DropdownMenuItem(value: cls, child: Text(cls)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                  selectedSubject = subjectsByClass[selectedClass]!.first;
                  selectedChapter = null;
                  _chapterController.clear();
                  _notesController.clear();
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),

            // Select Subject
            Text("Select Subject",
                style: TextStyle(fontSize: screenWidth * 0.045)),
            DropdownButton<String>(
              value: selectedSubject,
              isExpanded: true,
              items: subjects
                  .map((subj) =>
                  DropdownMenuItem(value: subj, child: Text(subj)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value!;
                  selectedChapter = null;
                  _chapterController.clear();
                  _notesController.clear();
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),

            // Select Chapter
            Text("Select Chapter",
                style: TextStyle(fontSize: screenWidth * 0.045)),
            if (selectedClass == '12th' && selectedSubject == 'Accounts')
              DropdownButton<String>(
                value: selectedChapter,
                isExpanded: true,
                hint: const Text("Select Chapter"),
                items: accountsChapters
                    .map((chapter) =>
                    DropdownMenuItem(value: chapter, child: Text(chapter)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChapter = value!;
                  });
                },
              )
            else
              TextField(
                controller: _chapterController,
                decoration: const InputDecoration(
                    hintText: "Enter Chapter Name"),
              ),

            SizedBox(height: screenHeight * 0.02),

            // Notes TextArea (new)
            Text("Enter Notes (min 300 characters)",
                style: TextStyle(fontSize: screenWidth * 0.045)),
            TextField(
              controller: _notesController,
              maxLines: 10, // big text area; adjust as needed
              decoration: InputDecoration(
                hintText: "Type chapter notes here...",
                border: const OutlineInputBorder(),
                helperText: "Characters: ${_notesController.text.length}",
              ),
              onChanged: (_) => setState(() {}), // refresh char count
            ),

            SizedBox(height: screenHeight * 0.03),

// Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveChapterWithNotes,
                icon: const Icon(Icons.save),
                label: Text(isSaving ? 'Saving...' : 'Save Chapter & Notes'),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            if (isSaving) const Center(child: CircularProgressIndicator()),
            Text(
              statusMessage,
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ],
        ),
      ),
    );
  }
}


