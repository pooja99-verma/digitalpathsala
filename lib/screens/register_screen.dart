import 'package:digital_pathsala/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? selectedClass;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> _register() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     // ✅ Create user in Firebase Auth
  //     UserCredential userCredential =
  //     await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //
  //     // ✅ Save additional user info in Firestore
  //     await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'name': _nameController.text.trim(),
  //       'phone': _phoneController.text.trim(),
  //       'dob': _dobController.text.trim(),
  //       'class': selectedClass,
  //       'email': _emailController.text.trim(),
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });
  //
  //     if (!mounted) return;
  //
  //     // ✅ Show success message
  //     _showSnackBar("Registration successful! Please login.");
  //
  //     // ✅ Navigate to Login Screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const LoginScreen(role: '',)),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     String errorMsg = 'Something went wrong';
  //     if (e.code == 'email-already-in-use') {
  //       errorMsg = 'This email is already registered';
  //     } else if (e.code == 'weak-password') {
  //       errorMsg = 'Password should be at least 6 characters';
  //     }
  //     _showSnackBar(errorMsg);
  //   } catch (e) {
  //     _showSnackBar('Error: $e');
  //   }
  //
  //   if (mounted) {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ✅ Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // ✅ Save user data in main 'users' collection
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
        'class': selectedClass,
        'email': _emailController.text.trim(),
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ ALSO save under classes → selectedClass → students
      await _firestore
          .collection('classes')
          .doc(selectedClass)
          .collection('students')
          .doc(uid)
          .set({
        'uid': uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
        'class': selectedClass,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showSnackBar("✅ Student registered successfully!");

      // ✅ Go back to login or admin screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen(role: '')),
      );
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Something went wrong';
      if (e.code == 'email-already-in-use') {
        errorMsg = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        errorMsg = 'Password should be at least 6 characters';
      }
      _showSnackBar(errorMsg);
    } catch (e) {
      _showSnackBar('Error: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter password";
    if (value.length < 6) return "Must be at least 6 characters";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
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
                const Icon(Icons.school, size: 100, color: Colors.red),
                const SizedBox(height: 12),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'DIGITAL ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black45, offset: Offset(2,2), blurRadius: 3)],
                          )),
                      TextSpan(
                          text: 'पाठशाला',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black45, offset: Offset(2,2), blurRadius: 3)],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(_nameController, "Full Name", Icons.person),
                          const SizedBox(height: 16),
                          _buildTextField(_phoneController, "Phone Number", Icons.phone, inputType: TextInputType.phone),
                          const SizedBox(height: 16),
                          // Date of Birth field with calendar picker
                          TextFormField(
                            controller: _dobController,
                            style: const TextStyle(color: Colors.white),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2005),
                                firstDate: DateTime(1980),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.red,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                String formattedDate = "${pickedDate.day.toString().padLeft(2,'0')}/${pickedDate.month.toString().padLeft(2,'0')}/${pickedDate.year}";
                                setState(() => _dobController.text = formattedDate);
                              }
                            },
                            decoration: _inputDecoration("Date of Birth", Icons.calendar_today),
                            validator: (value) => value == null || value.isEmpty ? "Please select your DOB" : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedClass,
                            items: ["9th","10th","11th","12th","NEET","JEE"]
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) => setState(() => selectedClass = v),
                            validator: (v) => v==null ? "Please select class" : null,
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("Select Class"),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_emailController, "Email", Icons.email, inputType: TextInputType.emailAddress, validator: _validateEmail),
                          const SizedBox(height: 16),
                          _buildTextField(_passwordController, "Password", Icons.lock, isPassword: true, validator: _validatePassword),
                          const SizedBox(height: 16),
                          _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock_outline, isPassword: true, validator: _validateConfirmPassword),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: _isLoading ? null : _register,
                              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Already have an account? Login", style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false,
        TextInputType inputType = TextInputType.text,
        String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: inputType,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, [IconData? icon]) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black,
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
