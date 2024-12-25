import 'package:bpl_project_app/feature/AdminFantasy/admin_fantasy.dart';
import 'package:bpl_project_app/feature/AdminFixture/admin_fixture.dart';
import 'package:bpl_project_app/feature/AdminHomepage/admin_homepage.dart';
import 'package:bpl_project_app/feature/AdminTickets/admin_tickets.dart';
import 'package:bpl_project_app/feature/PointsTableAdmin/points_table_admin.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';
import 'package:file_picker/file_picker.dart'; // Import file picker package
import 'dart:io';

class AdminHighlightsPage extends StatefulWidget {
  final String email;

  const AdminHighlightsPage({super.key, required this.email});

  @override
  _AdminHighlightsPageState createState() => _AdminHighlightsPageState();
}

class _AdminHighlightsPageState extends State<AdminHighlightsPage> {
  late VideoPlayerController _villiarsController;
  late VideoPlayerController _finalController;
  late VideoPlayerController _highlightController;
  late ChewieController _chewieControllerVilliars;
  late ChewieController _chewieControllerFinal;
  late ChewieController _chewieControllerHighlight;

  // List to store uploaded video controllers
  List<ChewieController> uploadedVideos = [];
  List<String> uploadedTitles = [];

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
    for (var controller in uploadedVideos) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickAndUploadVideo() async {
    // Pick a video file using the file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      File videoFile = File(result.files.single.path!);

      // Create a new VideoPlayerController for the uploaded video
      VideoPlayerController videoController =
          VideoPlayerController.file(videoFile);

      // Create a new ChewieController for the uploaded video
      ChewieController chewieController = ChewieController(
        videoPlayerController: videoController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
        allowMuting: true,
      );

      setState(() {
        uploadedVideos.add(chewieController);
        uploadedTitles.add(
            result.files.single.name); // Store the video file name as the title
      });

      // Initialize the video controller
      await videoController.initialize();
    }
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
      drawer: _buildDrawer(),
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

              // Display dynamically uploaded videos
              for (int i = 0; i < uploadedVideos.length; i++)
                Column(
                  children: [
                    _buildVideoPlayer(uploadedVideos[i], uploadedTitles[i]),
                    const SizedBox(height: 20),
                  ],
                ),

              // Button to upload a new video
              ElevatedButton.icon(
                onPressed: _pickAndUploadVideo,
                icon: const Icon(Icons.upload),
                label: const Text("Upload Video"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 18, 250, 2),
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
