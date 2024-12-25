import 'package:flutter/material.dart';
//import 'package:bpl_project_app/feature/Otp/otp_page.dart'; // Ensure correct import path

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        backgroundColor: const Color.fromARGB(255, 2, 86, 5),
      ),
      body: Container(
        color: const Color.fromARGB(255, 2, 86, 5),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/logo.gif', height: 120),
            const SizedBox(height: 20),
            const Text(
              'Enter Email Address of your account',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'User Name/Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Passing email to the OtpPage using GetX
                //Get.to(() => OtpPage(email: emailController.text));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Updated to use backgroundColor
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text('NEXT', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
