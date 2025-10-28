import 'package:flutter/material.dart';
import 'home_screen.dart';

class FeesScreen extends StatelessWidget {
  final String className;
  const FeesScreen({super.key, required this.className});

  // Dummy fees data
  final List<Map<String, String>> feesList = const [
    {"title": "Tuition Fee", "amount": "₹5000"},
    {"title": "Lab Fee", "amount": "₹1500"},
    {"title": "Exam Fee", "amount": "₹1000"},
    {"title": "Library Fee", "amount": "₹500"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Fees - $className",
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
        child: feesList.isEmpty
            ? const Center(
          child: Text(
            "No fee details available",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: feesList.length,
          itemBuilder: (context, index) {
            final fee = feesList[index];
            return Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  fee['title']!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  fee['amount']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
