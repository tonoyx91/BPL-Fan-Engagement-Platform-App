import 'package:flutter/material.dart';

class ComillaPage extends StatelessWidget {
  const ComillaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comilla Victorians",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
      ),
      body: Container(
        color: Colors.black, // Set the background color to black
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Comilla Victorians Team",
                  style: TextStyle(
                    fontSize: 32, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow, // Changed text color to yellow
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color:
                            Colors.black, // Adding shadow for better visibility
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'lib/assets/Comillateam.png',
                    fit: BoxFit.contain,
                    width: double.infinity, // Set the width to take full space
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
