import 'package:flutter/material.dart';
import 'package:onborading_screen/Login%20Screens/Loginscreen.dart';
import 'package:onborading_screen/Login%20Screens/Signupscreen.dart';
class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top empty space
              SizedBox(height: 0.0),

              // Image illustration
              Container(
                height: 270,
                child: Center(
                  child: Image.asset(
                    'assets/images/welcom.png', // Replace with your image asset
                    fit: BoxFit.contain,
                  ),
                ),
              ),

                           SizedBox(height: 5,),
                                // "Join the Design Revolution" text
              Text(
                'Join the Design Revolution',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.lightBlue[900],
                  fontFamily: "Noto",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15,),
              // Login and Register buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 75.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Loginscreen()),
                        );
                      },
                      child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25), // White text
                      ),
                      style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.lightBlue[800], // Button background color
                      padding: EdgeInsets.symmetric(
                      vertical: 10.0,horizontal: 38,
                      ),
                        elevation: 10,
                      ),
                    ),

                    SizedBox(width: 35,),


                    TextButton(
                      onPressed: () {
                        // Register button functionality here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signupscreen()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black, fontSize: 20,)

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
