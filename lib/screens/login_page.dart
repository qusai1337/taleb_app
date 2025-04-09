import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError(context, "Email and password are required");
      return;
    }

    try {
      final response = await http.post(
      //  Uri.parse('http://localhost:3000/login'),
        Uri.parse('http://192.168.1.10:3000/login'),

        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: data['user'])),
        );
      } else {
        final data = json.decode(response.body);
        _showError(context, data['error']);
      }
    } catch (e) {
      _showError(context, "Connection error");
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
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
Align(
  alignment: Alignment.center, // أو جرب Alignment.centerRight
  child: Padding(
    padding: EdgeInsets.only(left: 40), // بتقدر تتحكم بالمسافة من اليمين
    child: Image.asset('assets/logo.png', height: 120),
  ),
),

     SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF008C8C)),
                    onPressed: () => login(context),
                    child: Text('LOG IN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                  },
                  child: Text('SIGN UP', style: TextStyle(color: Color(0xFF008C8C), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
