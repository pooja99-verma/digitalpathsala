//
//
// import 'package:flutter/material.dart';
// import 'dashboard_screen.dart';
//
// class ClassSelectionPage extends StatefulWidget {
//   const ClassSelectionPage({super.key});
//
//   @override
//   State<ClassSelectionPage> createState() => _ClassSelectionPageState();
// }
//
// class _ClassSelectionPageState extends State<ClassSelectionPage> {
//   String? selectedClass;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           "DIGITAL पाठशाला",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Teacher Photo
//               const CircleAvatar(
//                 radius: 120,
//                 backgroundImage: AssetImage("assets/teacherphoto.jpeg"),
//               ),
//               const SizedBox(height: 20),
//
//               // Welcome & Instructions
//               const Text(
//                 "👋 Welcome to DIGITAL पाठशाला",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.redAccent,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Please select your class to continue",
//                 style: TextStyle(color: Colors.white70, fontSize: 16),
//               ),
//               const SizedBox(height: 20),
//
//               // Class Dropdown
//               DropdownButtonFormField<String>(
//                 dropdownColor: Colors.grey[900],
//                 value: selectedClass,
//                 decoration: InputDecoration(
//                   labelText: "Select Class",
//                   labelStyle: const TextStyle(color: Colors.white70),
//                   filled: true,
//                   fillColor: Colors.grey[900],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.white24),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.redAccent),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 items: ["Class 9", "Class 10", "Class 11", "Class 12"]
//                     .map((cls) => DropdownMenuItem(
//                   value: cls,
//                   child: Text(cls, style: const TextStyle(color: Colors.white)),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedClass = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 30),
//
//               // Continue Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: selectedClass == null
//                       ? null
//                       : () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => DashboardScreen(
//                           selectedClass: selectedClass!,
//                         ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: const Text(
//                     "Continue",
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class ClassSelectionPage extends StatefulWidget {
  const ClassSelectionPage({super.key});

  @override
  State<ClassSelectionPage> createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelectionPage> with SingleTickerProviderStateMixin {
  String? selectedClass;
  late AnimationController _controller;
  late Animation<double> _avatarAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for teacher avatar
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _avatarAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Animated Teacher Avatar
                ScaleTransition(
                  scale: _avatarAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 120,
                      backgroundImage: AssetImage("assets/teacherphoto.jpeg"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Welcome Text
                const Text(
                  "👋 Welcome to DIGITAL पाठशाला",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 3)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please select your class to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),

                // Class Dropdown
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.grey[900],
                  value: selectedClass,
                  decoration: _dropdownDecoration("Select Class"),
                  style: const TextStyle(color: Colors.white),
                  items: ["Class 9", "Class 10", "Class 11", "Class 12", "NEET", "JEE"]
                      .map((cls) => DropdownMenuItem(
                    value: cls,
                    child: Text(
                      cls,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedClass == null
                        ? null
                        : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DashboardScreen(selectedClass: selectedClass!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.redAccent,
                      elevation: 6,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
