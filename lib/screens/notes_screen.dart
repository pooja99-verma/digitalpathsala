//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class StudentNotesScreen extends StatefulWidget {
//   final String studentUid;
//
//   const StudentNotesScreen({super.key, required this.studentUid});
//
//   @override
//   State<StudentNotesScreen> createState() => _StudentNotesScreenState();
// }
//
// class _StudentNotesScreenState extends State<StudentNotesScreen> {
//   final firestore = FirebaseFirestore.instance;
//   String studentClass = '';
//   List<String> subjects = [];
//   String selectedSubject = '';
//   List<Map<String, dynamic>> chapters = [];
//   bool isLoading = false;
//
//   Future<void> fetchStudentInfo() async {
//     final doc =
//     await firestore.collection('students').doc(widget.studentUid).get();
//     final data = doc.data();
//     if (data != null) {
//       setState(() {
//         studentClass = data['CLASS'] ?? '';
//         subjects = List<String>.from(data['SUBJECTS'] ?? []);
//       });
//     }
//   }
//
//   Future<void> fetchChapters(String subject) async {
//     setState(() {
//       isLoading = true;
//       chapters = [];
//     });
//
//     try {
//       final snapshot = await firestore
//           .collection('notes')
//           .doc(studentClass)
//           .collection('subjects')
//           .doc(subject)
//           .collection('chapters')
//           .orderBy('uploadedAt', descending: true)
//           .get();
//
//       setState(() {
//         chapters = snapshot.docs.map((doc) {
//           return {
//             'name': doc.id,
//             'pdfUrl': doc['pdfUrl'],
//           };
//         }).toList();
//       });
//     } catch (e) {
//       setState(() {
//         chapters = [];
//       });
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> openPdf(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open PDF')),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStudentInfo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "My Notes",
//           style: TextStyle(
//             color: Colors.redAccent,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 3,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.redAccent),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFF9FAFB), Color(0xFFEDEDED)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: size.width * 0.06, vertical: 16),
//           child: subjects.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Subjects",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // 📘 Subject Chips
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: subjects.map((subject) {
//                     final isSelected = subject == selectedSubject;
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: ChoiceChip(
//                         label: Text(
//                           subject,
//                           style: TextStyle(
//                             color: isSelected
//                                 ? Colors.white
//                                 : Colors.black87,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         selected: isSelected,
//                         selectedColor: Colors.redAccent,
//                         backgroundColor: Colors.grey.shade200,
//                         onSelected: (_) async {
//                           setState(() => selectedSubject = subject);
//                           await fetchChapters(subject);
//                         },
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                         elevation: 2,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // 📚 Chapters Section
//               if (selectedSubject.isNotEmpty)
//                 Text(
//                   "Chapters for $selectedSubject",
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//               const SizedBox(height: 12),
//
//               if (isLoading)
//                 const Expanded(
//                     child: Center(child: CircularProgressIndicator()))
//               else if (chapters.isEmpty && selectedSubject.isNotEmpty)
//                 const Expanded(
//                   child: Center(
//                     child: Text(
//                       "No notes available",
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 )
//               else if (chapters.isNotEmpty)
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: chapters.length,
//                       itemBuilder: (context, index) {
//                         final chapter = chapters[index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12.withOpacity(0.1),
//                                 blurRadius: 6,
//                                 offset: const Offset(2, 4),
//                               ),
//                             ],
//                           ),
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 8),
//                             leading: const CircleAvatar(
//                               backgroundColor: Colors.redAccent,
//                               child: Icon(Icons.picture_as_pdf,
//                                   color: Colors.white),
//                             ),
//                             title: Text(
//                               chapter['name'],
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             trailing: const Icon(Icons.arrow_forward_ios,
//                                 size: 18, color: Colors.redAccent),
//                             onTap: () => openPdf(chapter['pdfUrl']),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'chapter_details.dart';

// import 'chapter_notes_screen.dart'; // <-- Uncomment if you have this screen

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

  bool isSubjectsLoading = true;
  bool isChaptersLoading = false;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    await fetchStudentInfo();
    await fetchSubjectsFromNotesIfEmpty(); // fallback
    if (subjects.isNotEmpty) {
      setState(() => selectedSubject = subjects.first);
      await fetchChapters(selectedSubject);
    }
  }

  /// Fetch CLASS and SUBJECTS from students/{studentUid}
  Future<void> fetchStudentInfo() async {
    try {
      final doc = await firestore
          .collection('students')
          .doc(widget.studentUid)
          .get();
      final data = doc.data();

      if (data == null) {
        setState(() => isSubjectsLoading = false);
        return;
      }

      final fetchedClass = (data['CLASS'] ??
          data['Class'] ??
          data['class'] ??
          data['grade'] ??
          '') as String;

      final subjectsRaw = data['SUBJECTS'] ??
          data['Subjects'] ??
          data['subjects'] ??
          [];

      List<String> fetchedSubjects;
      if (subjectsRaw is List) {
        fetchedSubjects = subjectsRaw
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (subjectsRaw is String) {
        fetchedSubjects = subjectsRaw
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      } else {
        fetchedSubjects = [];
      }

      setState(() {
        studentClass = fetchedClass.trim();
        subjects = fetchedSubjects;
        isSubjectsLoading = false;
      });
    } catch (e) {
      setState(() {
        isSubjectsLoading = false;
        subjects = [];
      });
    }
  }

  /// If student doc has no subjects, derive available subjects from notes/{CLASS}/subjects/*
  Future<void> fetchSubjectsFromNotesIfEmpty() async {
    if (studentClass.isEmpty || subjects.isNotEmpty) return;

    try {
      final snapshot = await firestore
          .collection('notes')
          .doc(studentClass)
          .collection('subjects')
          .get();

      final derived = snapshot.docs.map((d) => d.id).toList();
      if (derived.isNotEmpty) {
        setState(() {
          subjects = derived;
        });
      }
    } catch (_) {
      // Ignore; keep subjects empty
    }
  }

  String _snippet(String? text, {int max = 120}) {
    final s = (text ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');
    if (s.isEmpty) return '';
    return s.length <= max ? s : '${s.substring(0, max)}…';
  }

  String _formatTs(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  /// Load chapters + include notes preview fields
  Future<void> fetchChapters(String subject) async {
    if (studentClass.isEmpty) return;

    setState(() {
      isChaptersLoading = true;
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

      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        final name = (data['chapterName'] as String?)?.trim();
        final notes = (data['notesContent'] as String?) ?? '';
        final updatedAt = (data['notesUpdatedAt'] as Timestamp?);
        final createdAt = (data['uploadedAt'] as Timestamp?);

        return {
          'id': doc.id,
          'name': (name?.isNotEmpty == true) ? name! : doc.id,
          'notesPreview': _snippet(notes, max: 120),
          'hasNotes': notes
              .trim()
              .isNotEmpty,
          'updatedAt': updatedAt,
          'uploadedAt': createdAt,
        };
      }).toList();

      setState(() {
        chapters = list;
      });
    } catch (e) {
      // If orderBy requires an index or uploadedAt missing, try without order
      try {
        final snapshot = await firestore
            .collection('notes')
            .doc(studentClass)
            .collection('subjects')
            .doc(subject)
            .collection('chapters')
            .get();

        final list = snapshot.docs.map((doc) {
          final data = doc.data();
          final name = (data['chapterName'] as String?)?.trim();
          final notes = (data['notesContent'] as String?) ?? '';
          final updatedAt = (data['notesUpdatedAt'] as Timestamp?);
          final createdAt = (data['uploadedAt'] as Timestamp?);

          return {
            'id': doc.id,
            'name': (name?.isNotEmpty == true) ? name! : doc.id,
            'notesPreview': _snippet(notes, max: 120),
            'hasNotes': notes
                .trim()
                .isNotEmpty,
            'updatedAt': updatedAt,
            'uploadedAt': createdAt,
          };
        }).toList();

        setState(() {
          chapters = list;
        });
      } catch (_) {
        setState(() {
          chapters = [];
        });
      }
    } finally {
      setState(() {
        isChaptersLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
              "My Notes", style: TextStyle(color: Colors.redAccent)),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isSubjectsLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              if (studentClass.isEmpty) ...[
          const Text(
          "Your class is not set. Contact admin.",
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        ],

        if (subjects.isEmpty) ...[
    const Text(
    "No subjects assigned to your profile.",
    style: TextStyle(color: Colors.white70),
    ),
    const SizedBox(height: 12),
    const Text(
    "Tip: Ensure students/{uid} has CLASS & SUBJECTS fields, "
    "or that notes/{CLASS}/subjects/* exists.",
    style: TextStyle(color: Colors.white38, fontSize: 12),
    ),
    ] else
    ...[
    const Text("Subjects:",
    style: TextStyle(color: Colors.white, fontSize: 18)),
    const SizedBox(height: 10),
    Wrap(
    spacing: 10,
    runSpacing: 10,
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
    backgroundColor: isSelected ? Colors.redAccent : Colors
        .grey[800],
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
    horizontal: 16, vertical: 10),
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

    if (isChaptersLoading)
    const Center(child: CircularProgressIndicator())
    else
    if (selectedSubject.isNotEmpty && chapters.isEmpty)
    const Text("No chapters available",
    style: TextStyle(color: Colors.white70))
    else
    if (chapters.isNotEmpty)
    Expanded(
    child: ListView.builder(
    itemCount: chapters.length,
    itemBuilder: (context, index) {
    final chapter = chapters[index];
    final name = chapter['name'] as String? ??
    'Untitled';
    final hasNotes = chapter['hasNotes'] as bool? ??
    false;
    final preview = chapter['notesPreview'] as String? ??
    '';
    final updatedAt = _formatTs(
    chapter['updatedAt'] as Timestamp?);
    final uploadedAt = _formatTs(
    chapter['uploadedAt'] as Timestamp?);
    final dateLabel = (updatedAt.isNotEmpty)
    ? 'Updated: $updatedAt'
        : (uploadedAt.isNotEmpty
    ? 'Uploaded: $uploadedAt'
        : '');

    return Card(
    color: Colors.grey[900],
    child: ListTile(
    leading: Icon(
    hasNotes ? Icons.note_alt : Icons
        .note_alt_outlined,
    color: hasNotes ? Colors.greenAccent : Colors
        .white70,
    ),
    title: Text(name, style: const TextStyle(
    color: Colors.white)),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    if (preview.isNotEmpty)
    Padding(
    padding: const EdgeInsets.only(
    top: 4.0, bottom: 4.0),
    child: Text(
    preview,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
    height: 1.3,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    if (dateLabel.isNotEmpty)
    Text(
    dateLabel,
    style: const TextStyle(
    color: Colors.white38,
    fontSize: 12),
    ),
    ],
    ),
    trailing: const Icon(
    Icons.chevron_right, color: Colors.white70),

    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) =>
    ChapterScreen(
    studentClass: studentClass,
    subject: selectedSubject,
    chapterName: name, // keep this as the chapter doc id or chapterName
    ),
    ),
    );
    }),
    );
    },
    ),
    ),
    ],
    ],
    ),
    ),
    );
  }
}