import 'dart:math';

import 'package:bpl_project_app/feature/AdminFixture/admin_fixture.dart';
import 'package:bpl_project_app/feature/PointsTableAdmin/points_table_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpl_project_app/feature/Comilla/comilla_team.dart';
import 'package:bpl_project_app/feature/AdminHomepage/admin_homepage.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart'; // Import ComillaPage

class AdminTeamPage extends StatelessWidget {
  final String email; // Add email parameter

  const AdminTeamPage({super.key, required this.email}); // Receive the email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bangladesh Premier League 2024",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
        actions: [
          // Add a button to show the logged-in user's email
          TextButton.icon(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            label: Text(
              email, // Show the user's email
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.snackbar("Logged in as", email);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(
              255, 18, 250, 2), // Set the background color to red
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BPL 2024',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('lib/assets/logo.gif'),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.home,
                text: 'HomePage',
                onTap: () {
                  Get.to(() => AdminHomepage(
                      email: email)); // Navigate to HomePage with email
                },
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                text: 'Fixtures',
                onTap: () {
                  Get.to(() => AdminFixturePage(
                      email: email)); // Navigate to FixturePage with email
                },
              ),
              _buildDrawerItem(
                icon: Icons.people,
                text: 'Teams',
                onTap: () {
                  Get.to(() => AdminTeamPage(
                      email: email)); // Navigate to TeamPage with email
                },
              ),
              _buildDrawerItem(
                icon: Icons.table_chart,
                text: 'Points Table',
                onTap: () {
                  Get.to(() => PointsTableAdminPage(
                      email: email)); // Add navigation to Points Table page
                },
              ),
              _buildDrawerItem(
                icon: Icons.highlight,
                text: 'Highlights',
                onTap: () {
                  // Add navigation to Highlights page
                },
              ),
              _buildDrawerItem(
                icon: Icons.sports_cricket,
                text: 'Fantasy',
                onTap: () {
                  // Add navigation to Fantasy page
                },
              ),
              _buildDrawerItem(
                icon: Icons.confirmation_number,
                text: 'Tickets',
                onTap: () {
                  // Add navigation to Tickets page
                },
              ),
              const Divider(),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Sign Out',
                onTap: () {
                  Get.to(() => SignInPage()); // Sign Out logic
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "TEAMS",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildTeamCard('lib/assets/Barishal.png', 'Fortune Barishal'),
                  _buildTeamCard(
                      'lib/assets/Comilla.png', 'Comilla Victorians'),
                  _buildTeamCard('lib/assets/Dhaka.png', 'Dhaka Dominators'),
                  _buildTeamCard('lib/assets/Sylhet.png', 'Sylhet Strikers'),
                  _buildTeamCard('lib/assets/Rangpur.png', 'Rangpur Riders'),
                  _buildTeamCard(
                      'lib/assets/Chattogram.png', 'Chattogram Challengers'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTeamCard(String imagePath, String teamName) {
    return GestureDetector(
      onTap: () {
        // Handle navigation to ComillaPage when the card is tapped
        if (teamName == 'Comilla Victorians') {
          Get.to(() => const ComillaPage());
        } else {
          // Handle other team navigations if needed
          print('$teamName card tapped');
        }
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 150), // Increased size
              const SizedBox(height: 10),
              Text(
                teamName,
                style: const TextStyle(
                  fontSize: 30, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 203, 220, 147),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
