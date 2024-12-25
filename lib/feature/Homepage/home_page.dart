import 'package:bpl_project_app/feature/Fantasy/fantasy_page.dart';
import 'package:bpl_project_app/feature/Highlights/highlights.dart';
import 'package:bpl_project_app/feature/Tickets/tickets_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpl_project_app/feature/Fixture/fixture_page.dart';
import 'package:video_player/video_player.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';
import 'package:bpl_project_app/feature/Teams/team_page.dart';
import 'package:bpl_project_app/feature/PointsTable/points_table.dart';
import 'package:bpl_project_app/feature/Quiz/quiz_page.dart';

class HomePage extends StatefulWidget {
  final String email; // Add email parameter

  const HomePage({super.key, required this.email}); // Receive the email

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/BPL2023.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Mute the video
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BPL Fan Engagement Platform",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
        actions: [
          // Add a button to show the logged-in user's email
          TextButton.icon(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            label: Text(
              widget.email, // Show the user's email
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.snackbar("Logged in as", widget.email);
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
                  Get.to(() => HomePage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                text: 'Fixtures',
                onTap: () {
                  Get.to(() => FixturePage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.people,
                text: 'Teams',
                onTap: () {
                  Get.to(() => TeamPage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.table_chart,
                text: 'Points Table',
                onTap: () {
                  Get.to(() => PointsTablePage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.highlight,
                text: 'Highlights',
                onTap: () {
                  Get.to(() => HighlightsPage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.sports_cricket,
                text: 'Fantasy',
                onTap: () {
                  Get.to(() => BPLFantasyLeaguePage(
                      email: widget.email)); // Add navigation to Fantasy page
                },
              ),
              _buildDrawerItem(
                icon: Icons.confirmation_number,
                text: 'Tickets',
                onTap: () {
                  Get.to(() => TicketsPage(email: widget.email));
                },
              ),
              const Divider(),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Sign Out',
                onTap: () {
                  Get.to(() => SignInPage()); // Add Sign Out logic
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 11, 79, 14), Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Image.asset('lib/assets/logo.gif', height: 120),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Welcome to BPL Fan Engagement Platform",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 223, 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: OverflowBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureButton(
                      'Live Score',
                      'lib/assets/livescore.png',
                      () {
                        //Get.to(() => LivePage());
                      },
                    ),
                    _buildFeatureButton(
                      'Daily Quiz',
                      'lib/assets/quiz.png',
                      () {
                        Get.to(() => QuizPage(email: widget.email));
                      },
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

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFeatureButton(
      String title, String imagePath, VoidCallback onTap) {
    return Column(
      children: [
        Image.asset(imagePath, width: 100, height: 100),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.yellow, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: 160,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextButton(
            onPressed: onTap,
            child: Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
