// import 'package:digital_pathsala/screens/role_selection_screen.dart';
// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;
//
//   final List<Map<String, dynamic>> onboardingData = [
//     {
//       "title": "Learn from Experts",
//       "subtitle": "Access quality video lectures & notes anytime.",
//       "icon": Icons.school,
//     },
//     {
//       "title": "Track Your Progress",
//       "subtitle": "Monitor your performance and attendance easily.",
//       "icon": Icons.bar_chart,
//     },
//     {
//       "title": "Get Ready for Success",
//       "subtitle": "Prepare for Class 9–12 & competitive exams.",
//       "icon": Icons.emoji_events,
//     },
//   ];
//
//   void _completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_seen', true);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _controller,
//               onPageChanged: (index) => setState(() => _currentPage = index),
//               itemCount: onboardingData.length,
//               itemBuilder: (context, index) => Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       onboardingData[index]['icon'],
//                       size: 120,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 30),
//                     Text(
//                       onboardingData[index]['title'],
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       onboardingData[index]['subtitle'],
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               onboardingData.length,
//                   (index) => Container(
//                 margin: const EdgeInsets.all(5),
//                 width: _currentPage == index ? 20 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: _currentPage == index ? Colors.red : Colors.grey,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: _currentPage == onboardingData.length - 1
//                   ? _completeOnboarding
//                   : () {
//                 _controller.nextPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                 );
//               },
//               child: Text(
//                 _currentPage == onboardingData.length - 1
//                     ? "Get Started"
//                     : "Next",
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }


import 'package:digital_pathsala/screens/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Learn from Experts",
      "subtitle": "Access quality video lectures & notes anytime.",
      "icon": Icons.school_outlined,
      "color": Colors.orangeAccent,
    },
    {
      "title": "Track Your Progress",
      "subtitle": "Monitor your performance and attendance easily.",
      "icon": Icons.bar_chart_rounded,
      "color": Colors.lightBlueAccent,
    },
    {
      "title": "Get Ready for Success",
      "subtitle": "Prepare for Class 9–12 & competitive exams.",
      "icon": Icons.emoji_events_outlined,
      "color": Colors.greenAccent,
    },
  ];

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF111111)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutBack,
                            height: size.width * 0.5,
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  data['color'].withOpacity(0.1),
                                  Colors.redAccent.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              data['icon'],
                              size: size.width * 0.3,
                              color: data['color'],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: data['color'],
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            data['subtitle'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentPage == index
                          ? onboardingData[index]['color']
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Next / Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.orangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _currentPage == onboardingData.length - 1
                        ? _completeOnboarding
                        : () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      _currentPage == onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
