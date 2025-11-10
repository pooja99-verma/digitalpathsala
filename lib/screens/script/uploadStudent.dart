import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> uploadStudentsFromCSV() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Load CSV from assets
  final csvData = await rootBundle.loadString('assets/students_with_email_password.csv');
  final lines = const LineSplitter().convert(csvData);

  // Skip header
  for (var i = 1; i < lines.length; i++) {
    final values = lines[i].split(',');

    final name = values[0].trim();
    final studentClass = values[1].trim();
    final email = values[2].trim();
    final password = values[3].trim();

    try {
      // ✅ Create Firebase Auth user
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // ✅ Save details in Firestore
      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'class': studentClass,
        'email': email,
        'attendance': {},
        'notes': {},
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Registered: $name ($email)');
    } catch (e) {
      print('❌ Error for $email: $e');
    }
  }
}