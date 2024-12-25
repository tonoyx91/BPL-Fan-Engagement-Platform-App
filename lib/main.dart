import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For navigation
import 'package:animate_do/animate_do.dart'; // For animation effects
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart'; // Adjust the path to your file structure
import 'package:bpl_project_app/feature/SignUp/sign_up_page.dart'; // Import your SignUpPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use GetMaterialApp for navigation
      title: 'BPL Project App',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: ThemeData(
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 34, 30, 30), // Background color
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.green
            ], // Red to green gradient for background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeIn(
                // Fade-in effect for the welcome text
                duration: const Duration(seconds: 2),
                child: const Text(
                  "Welcome to BPL Fan Engagement platform",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              BounceInDown(
                // Bounce-in effect for the Sign Up button
                duration: const Duration(seconds: 2),
                child: ElevatedButton(
                  onPressed: () {
                    // Action for Sign Up
                    Get.to(() => SignUpPage());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    backgroundColor: Colors.green, // Solid green button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BounceInUp(
                // Bounce-in effect for the Sign In button
                duration: const Duration(seconds: 2),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the SignInPage when the Sign In button is pressed
                    Get.to(() => SignInPage());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    backgroundColor: Colors.red, // Solid red button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
