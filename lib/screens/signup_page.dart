import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signup(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
      _showError(context, "All fields are required");
      return;
    }

    if (!email.contains('edu') && !email.contains('student')) {
      _showError(context, "Email must contain .edu or student");
      return;
    }

    if (pass.length < 8) {
      _showError(context, "Password must be at least 8 characters long");
      return;
    }

    if (pass != confirmPass) {
      _showError(context, "Passwords do not match");
      return;
    }

    try {
      final response = await http.post(
     //   Uri.parse('http://localhost:3000/signup'),
                Uri.parse('http://192.168.1.10:3000/signup'),

        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': pass}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Success"),
            content: Text("Account created successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // dialog
                  Navigator.pop(context); // back to login
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      } else if (response.statusCode == 409) {
        _showError(context, "This username already exists.");
      } else {
        _showError(context, data['error'] ?? 'Something went wrong');
      }
    } catch (e) {
      _showError(context, "Connection error");
    }
  }

  void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008C8C),
                    )),
                SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'University Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008C8C),
                    ),
                    onPressed: () => signup(context),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(color: Color(0xFF008C8C)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
