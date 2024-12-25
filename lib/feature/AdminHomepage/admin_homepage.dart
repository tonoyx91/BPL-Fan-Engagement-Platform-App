import 'package:bpl_project_app/feature/AdminFantasy/admin_fantasy.dart';
import 'package:bpl_project_app/feature/AdminHighlights/Admin_highlights.dart';
import 'package:bpl_project_app/feature/AdminQuiz/admin_quiz.dart';
import 'package:bpl_project_app/feature/AdminTickets/admin_tickets.dart';
import 'package:bpl_project_app/feature/PointsTableAdmin/points_table_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpl_project_app/feature/AdminFixture/admin_fixture.dart';
import 'package:video_player/video_player.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';

class AdminHomepage extends StatefulWidget {
  final String email;

  const AdminHomepage({super.key, required this.email});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomepage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/BPL2023.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0);
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
          TextButton.icon(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            label: Text(
              widget.email,
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
                  Get.to(() => AdminHomepage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                text: 'Fixtures',
                onTap: () {
                  Get.to(() => AdminFixturePage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.table_chart,
                text: 'Points Table',
                onTap: () {
                  Get.to(() => PointsTableAdminPage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.highlight,
                text: 'Highlights',
                onTap: () {
                  Get.to(() => AdminHighlightsPage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.sports_cricket,
                text: 'Fantasy',
                onTap: () {
                  Get.to(() => FantasyAdminPage(email: widget.email));
                },
              ),
              _buildDrawerItem(
                icon: Icons.confirmation_number,
                text: 'Tickets',
                onTap: () {
                  Get.to(() => AdminTicketsPage(email: widget.email));
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
                  "BPL Fan Engagement Platform Admin Dashboard",
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
                        // Add Live Score navigation
                      },
                    ),
                    _buildFeatureButton(
                      'Daily Quiz',
                      'lib/assets/quiz.png',
                      () {
                        Get.to(() => AdminQuizPage(email: widget.email));
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
