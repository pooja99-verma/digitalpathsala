import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentNotesScreen extends StatefulWidget {
  final String studentUid;

  const StudentNotesScreen({super.key, required this.studentUid});

  @override
  State<StudentNotesScreen> createState() => _StudentNotesScreenState();
}

class _StudentNotesScreenState extends State<StudentNotesScreen> {
  final firestore = FirebaseFirestore.instance;
  String studentClass = '';
  List<String> subjects = [];
  String selectedSubject = '';
  List<Map<String, dynamic>> chapters = [];
  bool isLoading = false;

  Future<void> fetchStudentInfo() async {
    final doc = await firestore.collection('students').doc(widget.studentUid).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        studentClass = data['CLASS'] ?? '';
        subjects = List<String>.from(data['SUBJECTS'] ?? []);
      });
    }
  }

  Future<void> fetchChapters(String subject) async {
    setState(() {
      isLoading = true;
      chapters = [];
    });

    try {
      final snapshot = await firestore
          .collection('notes')
          .doc(studentClass)
          .collection('subjects')
          .doc(subject)
          .collection('chapters')
          .orderBy('uploadedAt', descending: true)
          .get();

      setState(() {
        chapters = snapshot.docs.map((doc) {
          return {
            'name': doc.id,
            'pdfUrl': doc['pdfUrl'],
          };
        }).toList();
      });
    } catch (e) {
      setState(() {
        chapters = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> openPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open PDF')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Notes", style: TextStyle(color: Colors.redAccent)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subjects.isEmpty)
              const Center(child: CircularProgressIndicator())
            else ...[
              const Text("Subjects:", style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: subjects.map((subject) {
                  final isSelected = subject == selectedSubject;
                  return ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        selectedSubject = subject;
                      });
                      await fetchChapters(subject);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.redAccent : Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                    child: Text(subject),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (selectedSubject.isNotEmpty)
                Text(
                  "Chapters for $selectedSubject:",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              const SizedBox(height: 10),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (chapters.isEmpty && selectedSubject.isNotEmpty)
                const Text("No notes available", style: TextStyle(color: Colors.white70))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text(chapter['name'], style: const TextStyle(color: Colors.white)),
                          trailing: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                          onTap: () => openPdf(chapter['pdfUrl']),
                        ),
                      );
                    },
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }
}