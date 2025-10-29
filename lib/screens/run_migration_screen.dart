import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RunMigrationScreen extends StatefulWidget {
  const RunMigrationScreen({super.key});

  @override
  State<RunMigrationScreen> createState() => _RunMigrationScreenState();
}

class _RunMigrationScreenState extends State<RunMigrationScreen> {
  bool _isRunning = false;
  String _status = "";

  Future<void> _runMigration() async {
    setState(() {
      _isRunning = true;
      _status = "Starting migration...";
    });

    final firestore = FirebaseFirestore.instance;

    try {
      final usersSnapshot = await firestore.collection('users').get();

      if (usersSnapshot.docs.isEmpty) {
        setState(() => _status = "❌ No users found.");
        return;
      }

      int count = 0;

      for (var user in usersSnapshot.docs) {
        final data = user.data();
        final classId = data['classId'];
        final name = data['name'];
        final subjects = data['subjects'];

        if (classId == null) continue;

        await firestore
            .collection('classes')
            .doc(classId)
            .collection('students')
            .doc(user.id)
            .set({
          'name': name,
          'subjects': subjects,
          'classId': classId,
        });

        count++;
      }

      setState(() => _status = "✅ Migration done successfully for $count students!");
    } catch (e) {
      setState(() => _status = "⚠️ Error: $e");
    } finally {
      setState(() => _isRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Run Migration", style: TextStyle(color: Colors.redAccent)),
        centerTitle: true,
      ),
      body: Center(
        child: _isRunning
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(_status, style: const TextStyle(color: Colors.white)),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: _runMigration,
              child: const Text("Run Migration Now"),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
