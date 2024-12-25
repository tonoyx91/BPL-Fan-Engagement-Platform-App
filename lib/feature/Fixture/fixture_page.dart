import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bpl_project_app/feature/Homepage/home_page.dart';
import 'package:bpl_project_app/feature/Teams/team_page.dart';
import 'package:bpl_project_app/feature/Highlights/highlights.dart';
import 'package:bpl_project_app/feature/PointsTable/points_table.dart';
import 'package:bpl_project_app/feature/Tickets/tickets_page.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';

class FixturePage extends StatefulWidget {
  final String email;

  const FixturePage({super.key, required this.email});

  @override
  _FixturePageState createState() => _FixturePageState();
}

class _FixturePageState extends State<FixturePage> {
  List<dynamic> fixtures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFixtures(); // Call the API when the page loads
  }

  Future<void> _fetchFixtures() async {
    try {
      final response = await http.get(Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-fixtures'));
      if (response.statusCode == 200) {
        setState(() {
          fixtures = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
            "Error", "Failed to load fixtures: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bangladesh Premier League 2024 Fixtures",
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Bangladesh Premier League 2024",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Fixtures",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _buildFixturesGrid(constraints),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
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
              onTap: () {},
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

  Widget _buildFixturesGrid(BoxConstraints constraints) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (constraints.maxWidth > 800)
            ? 3
            : (constraints.maxWidth > 400)
                ? 2
                : 1,
        childAspectRatio: (constraints.maxWidth > 400) ? 2.5 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: fixtures.length,
      itemBuilder: (context, index) {
        final fixture = fixtures[index];
        return _buildFixtureCard(
          fixture['team1'],
          fixture['team2'],
          fixture['date'],
        );
      },
    );
  }

  Widget _buildFixtureCard(String team1, String team2, String date) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.pink,
      const Color.fromARGB(255, 50, 227, 85),
      Colors.orange,
      Colors.purple
    ];
    final color = colors[team1.length % colors.length];

    // Parse and format the date for display
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);

    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate, // Display the formatted date
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "$team1 vs $team2",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
