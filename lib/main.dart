

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:onborading_screen/Home%20Page/homepage.dart';
import 'package:onborading_screen/Login%20Screens/Welcomescreen.dart';
import 'package:onborading_screen/Onboarding%20Screens/onboarding_screen.dart';
import 'package:onborading_screen/Login%20Screens/Loginscreen.dart'; // Import the login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with proper error handling
  try {
    await Firebase.initializeApp();
    runApp(const MyApp()); // Launch the app when Firebase is initialized
  } catch (error) {
    print("Error initializing Firebase: ${error.toString()}");
    // Show an error screen in case of Firebase initialization failure
    runApp(const FirebaseErrorApp());
  }
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onboarding App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a theme for the app
      ),
      // Check if the user is logged in
      home: _checkUserLogin(),
    );
  }

  Widget _checkUserLogin() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    // If user is logged in, go to MainHomePage, else go to Login Page
    if (user != null) {
      return MainHomePage(); // Show Home Page
    } else {
      return Welcomescreen(); // Show Login Page
    }
  }
}

// Error App to handle Firebase initialization failures
class FirebaseErrorApp extends StatelessWidget {
  const FirebaseErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirebaseErrorScreen(), // Error Screen wrapped in MaterialApp
    );
  }
}

// Error Screen displayed when Firebase fails to initialize
class FirebaseErrorScreen extends StatelessWidget {
  const FirebaseErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Initialization Error"),
      ),
      body: const Center(
        child: Text(
          "Failed to initialize Firebase. Please try again later.",
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
