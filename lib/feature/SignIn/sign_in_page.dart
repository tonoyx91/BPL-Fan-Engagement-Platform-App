import 'package:bpl_project_app/feature/AdminHomepage/admin_homepage.dart';
import 'package:bpl_project_app/feature/ForgetPassword/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bpl_project_app/feature/Homepage/home_page.dart'; // Import your HomePage
import 'package:bpl_project_app/feature/SignUp/sign_up_page.dart'; // Import your SignUpPage

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    var url = Uri.parse(
        'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/login'); // Replace with your API endpoint

    var body = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Success: Show success alert and navigate based on email
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Login successful!"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    if (email == "admin@gmail.com") {
                      Get.to(() => AdminHomepage(
                          email: email)); // Navigate to AdminHomepage
                    } else {
                      Get.to(
                          () => HomePage(email: email)); // Navigate to HomePage
                    }
                  },
                ),
              ],
            );
          },
        );
      } else {
        var message = jsonDecode(response.body)['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content:
                const Text("Failed to connect to the server. Try again later."),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign In",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 86, 5), // AppBar color
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white, // Set the main background color to white
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Image.asset('lib/assets/logo.gif', height: 120), // Logo
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome to BPL Fan Engagement Platform",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please Sign In here",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.green[50], // Light green background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.green[50], // Light green background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Get.to(() =>
                            ForgetPassword()); // Navigation to Forgot Password Page
                      },
                      child: const Text(
                        "Forgot Password? click here",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _login(context); // Call the login function
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.yellow,
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUpPage());
                      },
                      child: const Text(
                        "Don’t have an account? Sign Up",
                        style:
                            TextStyle(color: Color.fromARGB(255, 33, 243, 65)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 2, 86, 5),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Copyright reserved © BPL 2024",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
