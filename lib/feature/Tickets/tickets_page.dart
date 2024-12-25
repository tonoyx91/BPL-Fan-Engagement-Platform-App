import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bpl_project_app/feature/Fixture/fixture_page.dart';
import 'package:bpl_project_app/feature/Homepage/home_page.dart';
import 'package:bpl_project_app/feature/SignIn/sign_in_page.dart';
import 'package:bpl_project_app/feature/Teams/team_page.dart';
import 'package:bpl_project_app/feature/PointsTable/points_table.dart';

class TicketsPage extends StatefulWidget {
  final String email;

  const TicketsPage({Key? key, required this.email}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<dynamic> userTickets = [];
  final Map<String, int> initialSeats = {
    "Grand Stand": 5000,
    "East Gallery": 10000,
    "South Gallery": 8000,
    "North Gallery": 8000,
    "VIP Box": 500,
  };

  final Map<String, int> prices = {
    "East Gallery": 200,
    "North Gallery": 400,
    "South Gallery": 400,
    "Grand Stand": 600,
    "VIP Box": 3000,
  };

  String selectedStand = "";
  String selectedDate = "";
  int selectedQuantity = 0;
  bool isModalOpen = false;
  int availableSeats = 0;
  int ticketPrice = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchUserTickets();
  }

  Future<void> fetchUserTickets() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/user-tickets?email=${widget.email}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          userTickets = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (error) {
      print('Error fetching user tickets: $error');
    }
  }

  Future<void> bookTickets() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/book-ticket'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'seatNumber': selectedQuantity,
          'date': selectedDate,
          'totalPrize': totalPrice,
          'stand': selectedStand,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tickets booked successfully')),
        );
        fetchUserTickets(); // Refresh the tickets after booking
        setState(() {
          isModalOpen = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Warning! You cannot buy more than 5 tickets per day!')),
        );
      }
    } catch (error) {
      print('Error booking tickets: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to book tickets. Please try again.')),
      );
    }
  }

  Widget buildUserTickets() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: userTickets.length,
      itemBuilder: (BuildContext context, int index) {
        final ticket = userTickets[index];

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
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
                child: Text('Gallery: ${ticket['stand']}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.amber)),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text('Date: ${ticket['date']}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text('Quantity: ${ticket['seatNumber']}',
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
        title: const Text('Ticket Booking System'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Venue: Sher-e-Bangla National Cricket Stadium, Mirpur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              buildStadiumWidget(),
              const SizedBox(height: 20),
              const Text(
                'Max 5 tickets per match day per person',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
              if (isModalOpen) buildBookingModal(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Your Tickets:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              buildUserTickets(), // Display the user's booked tickets
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

  Widget buildStadiumWidget() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          border: Border.all(color: Colors.green, width: 4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildStandButton("East Gallery", Colors.blue, top: 30),
            buildStandButton("South Gallery", Colors.green, right: 10),
            buildStandButton("North Gallery", Colors.red, left: 10),
            buildStandButton(
                "Grand Stand", const Color.fromARGB(255, 6, 141, 87),
                bottom: 30),
            buildCenterPitch(),
          ],
        ),
      ),
    );
  }

  Widget buildStandButton(String standName, Color color,
      {double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedStand = standName;
            availableSeats = initialSeats[standName]!;
            ticketPrice = prices[standName]!;
            isModalOpen = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(standName, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildCenterPitch() {
    return const Center(
      child: Text(
        "Pitch",
        style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildBookingModal() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Booking for $selectedStand',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildDateSelector(),
          const SizedBox(height: 10),
          buildQuantitySelector(),
          const SizedBox(height: 10),
          Text('Unit Price: $ticketPrice BDT'),
          Text('Total Price: $totalPrice BDT'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: bookTickets,
            child: const Text('Book Tickets'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isModalOpen = false;
              });
            },
            child: const Text('Cancel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        hint: const Text('Select Match Day'),
        dropdownColor: Colors.grey[800],
        value: selectedDate.isEmpty ? null : selectedDate,
        items: List.generate(30, (index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          String formattedDate = "${date.year}-${date.month}-${date.day}";
          return DropdownMenuItem(
            value: formattedDate,
            child: Text(
              formattedDate,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }),
        onChanged: (value) {
          setState(() {
            selectedDate = value!;
          });
        },
        isExpanded: true,
        iconEnabledColor: Colors.greenAccent,
      ),
    );
  }

  Widget buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<int>(
        hint: const Text('Select Quantity'),
        dropdownColor: Colors.grey[800],
        value: selectedQuantity == 0 ? null : selectedQuantity,
        items: List.generate(5, (index) {
          int quantity = index + 1;
          return DropdownMenuItem(
            value: quantity,
            child: Text(
              '$quantity',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }),
        onChanged: (value) {
          setState(() {
            selectedQuantity = value!;
            totalPrice = selectedQuantity * ticketPrice;
          });
        },
        isExpanded: true,
        iconEnabledColor: Colors.greenAccent,
      ),
    );
  }
}
