import 'package:bpl_project_app/feature/PointsTable/points_table.dart';
import 'package:bpl_project_app/feature/Tickets/tickets_page.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:bpl_project_app/feature/Homepage/home_page.dart';
import 'package:bpl_project_app/feature/Fixture/fixture_page.dart';
import 'package:bpl_project_app/feature/Teams/team_page.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';

class HighlightsPage extends StatefulWidget {
  final String email; // Add email parameter

  const HighlightsPage({super.key, required this.email}); // Receive the email

  @override
  _HighlightsPageState createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> {
  late VideoPlayerController _villiarsController;
  late VideoPlayerController _finalController;
  late VideoPlayerController _highlightController;
  late ChewieController _chewieControllerVilliars;
  late ChewieController _chewieControllerFinal;
  late ChewieController _chewieControllerHighlight;

  @override
  void initState() {
    super.initState();
    _villiarsController =
        VideoPlayerController.asset('lib/assets/Villiars.mp4');
    _finalController = VideoPlayerController.asset('lib/assets/final.mp4');
    _highlightController =
        VideoPlayerController.asset('lib/assets/highlight.mp4');

    _chewieControllerVilliars = ChewieController(
      videoPlayerController: _villiarsController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      allowMuting: true,
    );

    _chewieControllerFinal = ChewieController(
      videoPlayerController: _finalController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      allowMuting: true,
    );

    _chewieControllerHighlight = ChewieController(
      videoPlayerController: _highlightController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      allowMuting: true,
    );
  }

  @override
  void dispose() {
    _villiarsController.dispose();
    _finalController.dispose();
    _highlightController.dispose();
    _chewieControllerVilliars.dispose();
    _chewieControllerFinal.dispose();
    _chewieControllerHighlight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Highlights",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
        actions: [
          // Show logged-in user's email
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
                  Get.to(() =>
                      HomePage(email: widget.email)); // Navigate to HomePage
                },
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                text: 'Fixtures',
                onTap: () {
                  Get.to(() => FixturePage(
                      email: widget.email)); // Navigate to FixturePage
                },
              ),
              _buildDrawerItem(
                icon: Icons.people,
                text: 'Teams',
                onTap: () {
                  Get.to(() =>
                      TeamPage(email: widget.email)); // Navigate to TeamPage
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
                  // Add navigation to Fantasy page
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
            colors: [Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildVideoPlayer(
                  _chewieControllerVilliars, 'AB de Villiers Highlights'),
              const SizedBox(height: 20),
              _buildVideoPlayer(
                  _chewieControllerFinal, 'Final Match Highlights'),
              const SizedBox(height: 20),
              _buildVideoPlayer(_chewieControllerHighlight, 'Match Highlights'),
              const SizedBox(height: 20),
            ],
          ),
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

  Widget _buildVideoPlayer(ChewieController chewieController, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: chewieController,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Divider(
          color: Colors.white.withOpacity(0.5),
          thickness: 1,
        ),
      ],
    );
  }
}
