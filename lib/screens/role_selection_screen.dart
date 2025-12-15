// import 'package:flutter/material.dart';
// import 'login_screen.dart';
//
// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.black, Colors.black87],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClipOval(
//               child: Image.asset(
//                 'assets/dpprofile.png',
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover, // ensures image fills the circle
//               ),
//             ),
//
//             const SizedBox(height: 16),
//             RichText(
//               text: const TextSpan(
//                 children: [
//                   TextSpan(
//                     text: 'DIGITAL ',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'पाठशाला',
//                     style: TextStyle(
//                       color: Colors.redAccent,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 50),
//             _buildRoleButton(
//               context,
//               title: "Login as Student",
//               icon: Icons.person,
//               color: Colors.blueAccent,
//               role: "student",
//             ),
//             const SizedBox(height: 20),
//             _buildRoleButton(
//               context,
//               title: "Login as Admin",
//               icon: Icons.admin_panel_settings,
//               color: Colors.redAccent,
//               role: "admin",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRoleButton(
//       BuildContext context, {
//         required String title,
//         required IconData icon,
//         required Color color,
//         required String role,
//       }) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => LoginScreen(role: role),
//             ),
//           );
//         },
//         icon: Icon(icon, color: Colors.white),
//         label: Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: CircleAvatar(
                    radius: width * 0.18,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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

                // App Title
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'DIGITAL ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'पाठशाला',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Choose your role to continue",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: height * 0.06),

                // Student Button
                _buildRoleButton(
                  context,
                  title: "Login as Student",
                  icon: Icons.person_outline,
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  role: "student",
                ),
                SizedBox(height: height * 0.02),

                // Admin Button
                _buildRoleButton(
                  context,
                  title: "Login as Admin",
                  icon: Icons.admin_panel_settings_outlined,
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  role: "admin",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required LinearGradient gradient,
        required String role,
      }) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(role: role),
              ),
            );
          },
          icon: Icon(icon, color: Colors.white),
          label: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
