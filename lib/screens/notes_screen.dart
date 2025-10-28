import 'package:flutter/material.dart';
import 'home_screen.dart';

class NotesScreen extends StatelessWidget {
  final String className;
  const NotesScreen({super.key, required this.className});

  // Sample data for notes (replace with Firestore data later)
  final List<Map<String, String>> notesList = const [
    {"title": "Math - Algebra", "description": "Algebra notes for chapter 1"},
    {"title": "Science - Physics", "description": "Newton's laws summary"},
    {"title": "English - Grammar", "description": "Tenses and usage"},
    {"title": "History - World War II", "description": "Important dates & events"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Notes - $className",
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.redAccent),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(selectedClass: className),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notesList.isEmpty
            ? const Center(
          child: Text(
            "No notes available",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  note['title']!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  note['description']!,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Colors.redAccent),
                onTap: () {
                  // TODO: Open detailed note page
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
