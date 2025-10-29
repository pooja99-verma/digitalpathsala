import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csv/csv.dart';
import 'firebase_options.dart'; // generated when you initialized Firebase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await uploadStudents();
}

Future<void> uploadStudents() async {
  final firestore = FirebaseFirestore.instance;

  // Load the CSV file from assets
  final rawData = await rootBundle.loadString('assets/students.csv');
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData, eol: '\n');

  // Skip header row
  for (int i = 1; i < csvTable.length; i++) {
    var row = csvTable[i];
    String uid = row[0].toString();
    String name = row[1].toString();
    String classId = row[2].toString();
    List<dynamic> subjects = jsonDecode(row[3]);

    // 1️⃣ Add student under users collection
    await firestore.collection('users').doc(uid).set({
      'name': name,
      'classId': classId,
      'subjects': subjects,
    });

    // 2️⃣ Add same student under class -> students subcollection
    await firestore
        .collection('classes')
        .doc(classId)
        .collection('students')
        .doc(uid)
        .set({
      'name': name,
      'subjects': subjects,
    });

    print('✅ Uploaded $name to $classId');
  }

  print("🎉 All students uploaded successfully!");
}
