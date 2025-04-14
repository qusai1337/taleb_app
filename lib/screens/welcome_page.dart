import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String selectedLang = 'EN';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLang = context.locale.languageCode.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  // Image.asset('assets/logo.png', height: 100),
                  SizedBox(height: 20),

                  Text(
                    "welcome_title".tr(),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    "taleb_plus".tr(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008C8C),
                    ),
                  ),
                  SizedBox(height: 40),

                  // login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF008C8C)),
                      child: Text("login".tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 15),

                  // sign up
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage())),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFF008C8C))),
                      child: Text("signup".tr(), style: TextStyle(color: Color(0xFF008C8C))),
                    ),
                  ),

                  // guest login
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage(user: {'name': 'Guest'})),
                      );
                    },
                    child: Text("guest_login".tr(), style: TextStyle(decoration: TextDecoration.underline)),
                  ),

                  Spacer(flex: 3),
                ],
              ),
            ),

            // language toggle
            Positioned(
              top: 16,
              left: 16,
              child: DropdownButton<String>(
                value: selectedLang,
                items: ['EN', 'AR'].map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLang = value!;
                    context.setLocale(Locale(value.toLowerCase()));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
