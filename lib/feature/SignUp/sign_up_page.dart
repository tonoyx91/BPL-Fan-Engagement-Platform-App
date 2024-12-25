import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding and decoding
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  /// This function validates the email format using a regular expression.
  bool _validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email format
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  Future<void> _signUp(BuildContext context) async {
    // Prepare the data
    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String country = countryController.text;
    String phone = phoneController.text;

    // Validate the email format before proceeding
    if (!_validateEmail(email)) {
      // Show error message if the email is invalid
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Email"),
            content: const Text("Please enter a valid email address."),
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
      return; // Stop further execution if the email is invalid
    }

    var url = Uri.parse(
        'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/signup'); // Replace with your API endpoint

    // Data to be sent to the API
    var body = {
      'fullName': fullName,
      'email': email,
      'password': password,
      'country': country,
      'phone': phone,
    };

    try {
      // Send POST request to the API
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Success: Show success alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("User registered successfully!"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Get.to(() => SignInPage()); // Navigate to Sign In Page
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error from the API: Show error alert
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
      // Handle error if API fails to respond
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
          "Sign Up",
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
                      "Join BPL Fan Engagement Platform",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Create an account by filling out the form below",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
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
                    TextField(
                      controller: countryController,
                      decoration: InputDecoration(
                        hintText: 'Country',
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
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        filled: true,
                        fillColor: Colors.green[50], // Light green background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Call the signup function when button is pressed
                        _signUp(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Colors.yellow, // Foreground color (text)
                        backgroundColor:
                            Colors.red, // Background color of the button
                        minimumSize:
                            const Size(double.infinity, 50), // Button size
                      ),
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => SignInPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        elevation: 0, // No shadow or elevation
                        foregroundColor: const Color.fromARGB(255, 33, 243, 65),
                      ),
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration:
                              TextDecoration.underline, // Underline effect
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(
                255, 2, 86, 5), // Set footer background to green
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Copyright reserved © BPL 2024",
              style: TextStyle(
                color: Colors.black, // Text color
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
