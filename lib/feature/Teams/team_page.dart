import 'package:bpl_project_app/feature/Chattogram/chattogram_page.dart';
import 'package:bpl_project_app/feature/Fantasy/fantasy_page.dart';
import 'package:bpl_project_app/feature/Highlights/highlights.dart';
import 'package:bpl_project_app/feature/Khulna/khulna_page.dart';
import 'package:bpl_project_app/feature/PointsTable/points_table.dart';
import 'package:bpl_project_app/feature/Rangpur/rangpur_page.dart';
import 'package:bpl_project_app/feature/Sylhet/sylhet_page.dart';
import 'package:bpl_project_app/feature/Tickets/tickets_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpl_project_app/feature/Comilla/comilla_team.dart';
import 'package:bpl_project_app/feature/Fixture/fixture_page.dart';
import 'package:bpl_project_app/feature/Homepage/home_page.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';
import 'package:bpl_project_app/feature/Dhaka/dhaka_team.dart'; // Import DhakaPage and other teams

class TeamPage extends StatelessWidget {
  final String email;

  const TeamPage({super.key, required this.email});

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
          // Show the logged-in user's email
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
                  Get.to(() => HomePage(
                      email: email)); // Navigate to HomePage with email
                },
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                text: 'Fixtures',
                onTap: () {
                  Get.to(() => FixturePage(
                      email: email)); // Navigate to FixturePage with email
                },
              ),
              _buildDrawerItem(
                icon: Icons.people,
                text: 'Teams',
                onTap: () {
                  Get.to(() => TeamPage(
                      email: email)); // Navigate to TeamPage with email
                },
              ),
              _buildDrawerItem(
                icon: Icons.table_chart,
                text: 'Points Table',
                onTap: () {
                  Get.to(() => PointsTablePage(email: email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.highlight,
                text: 'Highlights',
                onTap: () {
                  Get.to(() => HighlightsPage(email: email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.sports_cricket,
                text: 'Fantasy',
                onTap: () {
                  Get.to(() => BPLFantasyLeaguePage(email: email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.confirmation_number,
                text: 'Tickets',
                onTap: () {
                  Get.to(() => TicketsPage(email: email));
                },
              ),
              const Divider(),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Sign Out',
                onTap: () {
                  Get.to(() => SignInPage());
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap in SingleChildScrollView to allow vertical scrolling
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.7, // Adjust height to fit the screen
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2, // Adjust based on screen width
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      0.75, // Adjust aspect ratio to fit images better
                  children: [
                    _buildTeamCard('lib/assets/Khulna.png', 'Khulna Tigers'),
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
        // Navigate to the respective team page based on the team name
        if (teamName == 'Comilla Victorians') {
          Get.to(() => const ComillaPage());
        } else if (teamName == 'Dhaka Dominators') {
          Get.to(() => const DhakaPage());
        } else if (teamName == 'Khulna Tigers') {
          Get.to(() => const KhulnaPage()); // You need to create BarishalPage
        } else if (teamName == 'Sylhet Strikers') {
          Get.to(() => const SylhetPage()); // You need to create SylhetPage
        } else if (teamName == 'Rangpur Riders') {
          Get.to(() => const RangpurPage()); // You need to create RangpurPage
        } else if (teamName == 'Chattogram Challengers') {
          Get.to(() =>
              const ChattogramPage()); // You need to create ChattogramPage
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
              Flexible(
                child: Image.asset(imagePath,
                    height: 120), // Adjusted size for better layout
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  teamName,
                  style: const TextStyle(
                    fontSize: 24, // Adjusted font size for consistency
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 203, 220, 147),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Avoid text overflow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
