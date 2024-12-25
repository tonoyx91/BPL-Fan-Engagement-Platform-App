import 'dart:convert';
import 'package:bpl_project_app/feature/AdminFantasy/admin_fantasy.dart';
import 'package:bpl_project_app/feature/AdminFixture/admin_fixture.dart';
import 'package:bpl_project_app/feature/AdminHighlights/Admin_highlights.dart';
import 'package:bpl_project_app/feature/AdminHomepage/admin_homepage.dart';
import 'package:bpl_project_app/feature/Highlights/highlights.dart';
import 'package:bpl_project_app/feature/PointsTableAdmin/points_table_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';
import 'package:intl/intl.dart'; // Import this package for date formatting

class AdminTicketsPage extends StatefulWidget {
  final String email;

  const AdminTicketsPage({Key? key, required this.email}) : super(key: key);

  @override
  _AdminTicketsPageState createState() => _AdminTicketsPageState();
}

class _AdminTicketsPageState extends State<AdminTicketsPage> {
  List<dynamic> allTickets = [];

  @override
  void initState() {
    super.initState();
    fetchAllTickets();
  }

  Future<void> fetchAllTickets() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-all-tickets'),
      );

      if (response.statusCode == 200) {
        setState(() {
          allTickets = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (error) {
      print('Error fetching all tickets: $error');
    }
  }

  Widget buildAllTickets() {
    if (allTickets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No tickets have been booked yet.',
            style: TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Calculate the width of the screen and adjust the number of columns dynamically
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200
        ? 4
        : screenWidth > 800
            ? 3
            : 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            crossAxisCount, // Dynamically change columns based on screen width
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: allTickets.length,
      itemBuilder: (BuildContext context, int index) {
        final ticket = allTickets[index];

        DateTime date = DateTime.parse(ticket['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.green.shade900, Colors.green.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text('Booked by: ${ticket['email']}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text('Gallery: ${ticket['stand']}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber)),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text('Date: $formattedDate',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text('Seats: ${ticket['seatNumber']}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text('Total Price: ${ticket['totalPrize']} BDT',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tickets Overview'),
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
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'All Tickets Booked So Far',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(
                color: Colors.greenAccent,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              buildAllTickets(), // Display all tickets for all users
            ],
          ),
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
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
}
