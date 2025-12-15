// import 'package:digital_pathsala/screens/studentsscreens/%20student_dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'admin_dashboard.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   final String role; // "student" or "admin"
//   const LoginScreen({super.key, required this.role});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//
//
//
//
//   void _login() async {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       _showSnackBar("Please enter both email and password");
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//
//       // ✅ Save role in SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_role', widget.role);
//
//       if (widget.role == "admin" && email == 'digitalpathsalasitapur@gmail.com') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminDashboard()),
//           //AdminDashboardScreen()),
//         );
//       } else if (widget.role == "student" && email != 'digitalpathsalasitapur@gmail.com') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) =>
//           //const ClassSelectionPage()),
//           StudentDashboardScreen(className: '9')),
//          // HomeScreen(selectedClass: '', studentUid: '',)),
//         );
//       } else {
//         _showSnackBar("Invalid login for selected role");
//       }
//     } on FirebaseAuthException catch (e) {
//       String message = "Login failed";
//       if (e.code == 'user-not-found') {
//         message = "No account found for this email.";
//       } else if (e.code == 'wrong-password') {
//         message = "Incorrect password.";
//       }
//       _showSnackBar(message);
//     } catch (e) {
//       _showSnackBar("An error occurred: ${e.toString()}");
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.black, Colors.black87],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Icon(Icons.lock, size: 100, color: Colors.redAccent),
//                 const SizedBox(height: 20),
//                 Text(
//                   widget.role == "admin"
//                       ? "Admin Login"
//                       : "Student Login",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Card(
//                   color: Colors.grey[900],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: _emailController,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: _inputDecoration("Email", Icons.email),
//                         ),
//                         const SizedBox(height: 16),
//                      // declare this in your State class
//
//                     TextField(
//                     controller: _passwordController,
//                     style: const TextStyle(color: Colors.white),
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       labelStyle: const TextStyle(color: Colors.white),
//                       prefixIcon: const Icon(Icons.lock, color: Colors.white),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.redAccent,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                             ),
//                             onPressed: _isLoading ? null : _login,
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                                 : const Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       prefixIcon: Icon(icon, color: Colors.white70),
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.white70),
//       filled: true,
//       fillColor: Colors.black,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.white24),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.blueAccent),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }
// }
import 'package:digital_pathsala/screens/studentsscreens/%20student_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final String role; // "student" or "admin"
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter both email and password");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', widget.role);

      if (widget.role == "admin" &&
          email == 'digitalpathsalasitapur@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (widget.role == "student" &&
          email != 'digitalpathsalasitapur@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDashboardScreen(className: '9'),
          ),
        );
      } else {
        _showSnackBar("Invalid login for selected role");
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') {
        message = "No account found for this email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password.";
      }
      _showSnackBar(message);
    } catch (e) {
      _showSnackBar("An error occurred: ${e.toString()}");
    }

    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = widget.role == "admin";

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    child: const Icon(Icons.lock_outline,
                        size: 60, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  isAdmin ? "Admin Login" : "Student Login",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  isAdmin
                      ? "Welcome back, please manage your dashboard securely."
                      : "Log in to access your digital classroom.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 40),

                // Glass effect card
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Email", Icons.email),
                      ),
                      const SizedBox(height: 18),

                      // Password field
                      TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon:
                          const Icon(Icons.lock, color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() =>
                            _obscurePassword = !_obscurePassword),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white24),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 6,
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.transparent,
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
}
