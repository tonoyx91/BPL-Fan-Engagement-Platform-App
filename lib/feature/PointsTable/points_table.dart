import 'dart:convert'; // To parse JSON data
import 'package:bpl_project_app/feature/Homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // To make HTTP requests
import 'package:get/get.dart'; // For navigation and state management
import 'package:google_fonts/google_fonts.dart'; // For stylish fonts
import 'package:bpl_project_app/feature/Fantasy/fantasy_page.dart';
import 'package:bpl_project_app/feature/Highlights/highlights.dart';
import 'package:bpl_project_app/feature/Tickets/tickets_page.dart';
import 'package:bpl_project_app/feature/Fixture/fixture_page.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';
import 'package:bpl_project_app/feature/Teams/team_page.dart';
import 'package:bpl_project_app/feature/PointsTable/points_table.dart';
import 'package:bpl_project_app/feature/Quiz/quiz_page.dart';

class PointsTablePage extends StatefulWidget {
  final String email;

  const PointsTablePage({super.key, required this.email});

  @override
  _PointsTablePageState createState() => _PointsTablePageState();
}

class _PointsTablePageState extends State<PointsTablePage>
    with SingleTickerProviderStateMixin {
  List<dynamic> pointsTable = []; // List to hold points table data
  bool isLoading = true; // To show a loading spinner while fetching data

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    fetchPointsTable(); // Fetch points table on init
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to fetch the points table from the API
  Future<void> fetchPointsTable() async {
    final url = Uri.parse(
        'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-pointstable'); // Replace with your server URL
    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> fetchedData =
            json.decode(response.body); // Parse JSON response

        // Sort data in descending order by points, wins, and then netRunRate if points are equal
        fetchedData.sort((a, b) {
          if (a['points'] == b['points']) {
            if (a['win'] == b['win']) {
              return b['netRunRate'].compareTo(a[
                  'netRunRate']); // Sort by netRunRate if points and wins are equal
            }
            return b['win']
                .compareTo(a['win']); // Sort by wins if points are equal
          }
          return b['points']
              .compareTo(a['points']); // Sort by points in descending order
        });

        setState(() {
          pointsTable = fetchedData; // Update the state with sorted data
          isLoading = false; // Data loaded, hide spinner
          _controller.forward(); // Trigger animation
        });

        print('Data fetched and sorted successfully: ${response.body}');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false; // Hide spinner in case of failure
        });
      }
    } catch (error) {
      print('Error fetching points table: $error');
      setState(() {
        isLoading = false; // Hide spinner in case of failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Points Table",
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
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while data is loading
          : LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Stylish headline
                      FadeTransition(
                        opacity: _animation,
                        child: Text(
                          "BPL 2024 Points Table",
                          style: GoogleFonts.pacifico(
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Points table with colorful rows
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: FadeTransition(
                              opacity: _animation,
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.teal[800]!,
                                ),
                                columnSpacing: 20.0,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'TEAM',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'M',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'W',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'L',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'D',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'P',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'NRR',
                                      style: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: pointsTable.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var team = entry.value;

                                  // Alternating row colors
                                  final Color rowColor = index % 2 == 0
                                      ? const Color.fromARGB(255, 12, 165, 20)
                                      : const Color.fromARGB(255, 130, 43, 43);

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(team['teamName'] ?? '',
                                          style: const TextStyle(
                                              color: Colors.white))),
                                      DataCell(Text(
                                          team['totalMatches'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                      DataCell(Text(team['win'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                      DataCell(Text(team['losses'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                      DataCell(Text(team['draw'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                      DataCell(Text(team['points'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                      DataCell(Text(
                                          team['netRunRate'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                    ],
                                    color: MaterialStateProperty.resolveWith(
                                        (states) => rowColor),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Implementing the updated drawer design
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
                // Already on Points Table page
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
                Get.to(() => BPLFantasyLeaguePage(email: widget.email));
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
                Get.to(() => SignInPage());
              },
            ),
          ],
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
}
