

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onborading_screen/Home%20Page/homepage.dart';
import 'package:onborading_screen/Login%20Screens/Signupscreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to Home Page after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainHomePage()),
      );
    } catch (e) {
      print('Error: $e');
      // Handle login errors, show an alert dialog or message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login here',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue[900],
                fontFamily: "poppins",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18),
            Text(
              'Welcome back you’ve been missed!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: "poppins", fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.redAccent.shade200),
                labelText: 'Enter your Email',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.blue.shade50,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent.shade700),
                ),
              ),
            ),
            SizedBox(height: 25),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.lock, color: Colors.redAccent.shade200),
                fillColor: Colors.blue.shade50,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot your password?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.lightBlue[800],
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _login,
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "poppins", fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Signupscreen()),
                  );
                },
                child: Text(
                  'Create new account',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
