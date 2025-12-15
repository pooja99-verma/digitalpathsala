// import 'package:digital_pathsala/screens/role_selection_screen.dart';
// import 'package:digital_pathsala/screens/studentsscreens/%20student_dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'admin_dashboard.dart';
// import 'onboarding_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//
//   void _checkLoginStatus() async {
//     await Future.delayed(const Duration(seconds: 3));
//     final prefs = await SharedPreferences.getInstance();
//     bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
//     String? userRole = prefs.getString('user_role');
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && userRole != null) {
//       if (userRole == 'admin') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminDashboard()),
//           //AdminDashboardScreen()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const StudentDashboardScreen(className: '',)),
//         );
//       }
//     } else if (!onboardingSeen) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.black,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Animated Logo
//               TweenAnimationBuilder(
//                 tween: Tween<double>(begin: 0.0, end: 1.0),
//                 duration: const Duration(seconds: 2),
//                 builder: (context, value, child) => Opacity(
//                   opacity: value,
//                   child: Transform.scale(
//                     scale: 0.9 + 0.1 * value,
//                     child: child,
//                   ),
//                 ),
//                 child: const Icon(Icons.school, size: 100, color: Colors.red),
//               ),
//               const SizedBox(height: 15),
//               // App Name
//               RichText(
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'DIGITAL ',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'पाठशाला',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Smart Learning for Every Student",
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//               const SizedBox(height: 40),
//               // Loading indicator
//               const CircularProgressIndicator(
//                 color: Colors.red,
//                 strokeWidth: 3,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:digital_pathsala/screens/role_selection_screen.dart';
import 'package:digital_pathsala/screens/studentsscreens/%20student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_dashboard.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 0.9, end: 1.05).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

    _checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
    String? userRole = prefs.getString('user_role');
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && userRole != null) {
      if (userRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const StudentDashboardScreen(className: '')),
        );
      }
    } else if (!onboardingSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: CircleAvatar(
                  radius: width * 0.18,
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/dpprofile.png',
                        width: 120,         // set width
                        height: 120,        // set height
                        fit: BoxFit.cover,  // ensures image fills the circle
                      ),
                    )
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              // App Name
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'DIGITAL ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'पाठशाला',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Smart Learning for Every Student",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: height * 0.05),
              const CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
