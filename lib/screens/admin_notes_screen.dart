import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  File? selectedPdf;
  bool isUploading = false;
  String statusMessage = '';

  final _chapterController = TextEditingController();

  final List<String> classes = ['9th', '10th', '11th', '12th'];

  final Map<String, List<String>> subjectsByClass = {
    '9th': ['Science', 'Math'],
    '10th': ['Science', 'Math'],
    '11th': ['Physics', 'Biology', 'Math', 'Chemistry', 'Economics', 'Accounts'],
    '12th': ['Physics', 'Biology', 'Math', 'Chemistry', 'Economics', 'Accounts'],
  };

  final List<String> accountsChapters = [
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

  Future<void> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (!mounted) return;

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
        statusMessage = '✅ PDF selected: ${result.files.single.name}';
      });
    } else {
      setState(() {
        statusMessage = '⚠️ No file selected';
      });
    }
  }

  Future<void> uploadPdfNote() async {
    final chapterName = selectedSubject == 'Accounts' && selectedClass == '12th'
        ? selectedChapter
        : _chapterController.text;

    if (selectedPdf == null || chapterName!.isEmpty) {
      setState(() {
        statusMessage = '⚠️ Please select a PDF and enter/select chapter name';
      });
      return;
    }

    setState(() {
      isUploading = true;
      statusMessage = 'Uploading...';
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('notes/$selectedClass/$selectedSubject/$chapterName.pdf');

      final uploadTask = await storageRef.putFile(selectedPdf!);
      final pdfUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('notes')
          .doc(selectedClass)
          .collection('subjects')
          .doc(selectedSubject)
          .collection('chapters')
          .doc(chapterName)
          .set({
        'pdfUrl': pdfUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        statusMessage = '✅ PDF uploaded successfully!';
        _chapterController.clear();
        selectedPdf = null;
        selectedChapter = null;
      });
    } catch (e) {
      setState(() {
        statusMessage = '❌ Upload failed: $e';
      });
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjects = subjectsByClass[selectedClass]!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Notes')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Class", style: TextStyle(fontSize: screenWidth * 0.045)),
            DropdownButton<String>(
              value: selectedClass,
              isExpanded: true,
              items: classes.map((cls) {
                return DropdownMenuItem(value: cls, child: Text(cls));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                  selectedSubject = subjectsByClass[selectedClass]!.first;
                  selectedChapter = null;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Text("Select Subject", style: TextStyle(fontSize: screenWidth * 0.045)),
            DropdownButton<String>(
              value: selectedSubject,
              isExpanded: true,
              items: subjects.map((subj) {
                return DropdownMenuItem(value: subj, child: Text(subj));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value!;
                  selectedChapter = null;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Text("Select Chapter", style: TextStyle(fontSize: screenWidth * 0.045)),
            if (selectedClass == '12th' && selectedSubject == 'Accounts')
              DropdownButton<String>(
                value: selectedChapter,
                isExpanded: true,
                hint: const Text("Select Chapter"),
                items: accountsChapters.map((chapter) {
                  return DropdownMenuItem(value: chapter, child: Text(chapter));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChapter = value!;
                  });
                },
              )
            else
              TextField(
                controller: _chapterController,
                decoration: const InputDecoration(hintText: "Enter Chapter Name"),
              ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pickPdfFile,
                icon: const Icon(Icons.attach_file),
                label: const Text("Pick PDF"),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isUploading ? null : uploadPdfNote,
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Upload PDF"),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            if (isUploading) const Center(child: CircularProgressIndicator()),
            Text(statusMessage, style: TextStyle(fontSize: screenWidth * 0.04)),
          ],
        ),
      ),
    );
  }
}
