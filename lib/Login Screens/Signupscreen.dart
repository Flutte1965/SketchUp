// import 'package:flutter/material.dart';
// import 'package:onborading_screen/Login%20Screens/Loginscreen.dart';
// class Signupscreen extends StatelessWidget {
//   const Signupscreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//     backgroundColor: Colors.white,
//     body: Padding(
//     padding: EdgeInsets.all(16.0),
//     child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Text(
//         'Create Account',
//         style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Colors.lightBlue[900],
//             fontFamily: "poppins"
//         ),
//         textAlign: TextAlign.center,
//       ),
//
//     SizedBox(height: 8),
//     Text(
//     'Create an account so you can join design revolution',
//     textAlign: TextAlign.center,
//     style: TextStyle(fontSize: 16, color: Colors.black),
//     ),
//
//     SizedBox(height: 32),
//       TextField(
//         decoration: InputDecoration(
//           prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent.shade200),
//           labelText: 'Email',
//           labelStyle: TextStyle(color: Colors.grey),
//           fillColor: Colors.blue.shade50, // Minor shade color inside the text field
//           filled: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(13),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blueAccent.shade700),
//           ),
//         ),
//       ),
//     SizedBox(height: 10),
//       TextField(
//         obscureText: true,
//         decoration: InputDecoration(
//           labelText: 'Password',
//           labelStyle: TextStyle(color: Colors.grey),
//           prefixIcon: Icon(Icons.lock, color: Colors.redAccent.shade200),
//           fillColor: Colors.blue.shade50, // Minor shade color inside the text field
//           filled: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(13),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blueAccent),
//           ),
//         ),
//       ),
//
//     SizedBox(height: 10),
//       TextField(
//         obscureText: true,
//         decoration: InputDecoration(
//           labelText: ' Confirm Password',
//           labelStyle: TextStyle(color: Colors.grey),
//           prefixIcon: Icon(Icons.lock, color: Colors.redAccent.shade200),
//           fillColor: Colors.blue.shade50, // Minor shade color inside the text field
//           filled: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(13),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blueAccent),
//           ),
//         ),
//       ),
//     SizedBox(height: 32),
//
//
//
//     SizedBox(
//     width: double.infinity,
//     height: 50,
//     child:
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         backgroundColor: Colors.lightBlue[800],
//         elevation: 15,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       onPressed: () {
//         // Sign in action
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Loginscreen()),
//         );
//       },
//       child: Text(
//         'Sign Up',
//         style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "poppins",fontWeight: FontWeight.w700),
//       ),
//     ),
//     ),
//     SizedBox(height: 16),
//
//
//       TextButton(
//         onPressed: () {
//           // Create new account action
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Loginscreen()),
//           );
//         },
//         child: Text(
//           ''
//               'Already have an account',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//     ],
//     ),
//     ),
//     );
//     }
//     }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onborading_screen/Login%20Screens/Loginscreen.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      // Handle password mismatch
      print('Passwords do not match');
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to Login Page after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    } catch (e) {
      print('Error: $e');
      // Handle signup errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue[900],
                  fontFamily: "poppins"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Create an account so you can join the design revolution',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent.shade200),
                labelText: 'Email',
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.lightBlue[800],
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _signUp,
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "poppins", fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Loginscreen()),
                );
              },
              child: Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
