// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final _auth = FirebaseAuth.instance;
//
//   Future<bool> login(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return true;
//     } catch (e) {
//       print("Login error: $e");
//       return false;
//     }
//   }
//
//   Future<bool> register(String email, String password) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       return true;
//     } catch (e) {
//       print("Register error: $e");
//       return false;
//     }
//   }
// }
