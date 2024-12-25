import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting

class FantasyAdminPage extends StatefulWidget {
  final String email; // Add the email parameter

  FantasyAdminPage({required this.email}); // Constructor to accept the email

  @override
  _FantasyAdminPageState createState() => _FantasyAdminPageState();
}

class _FantasyAdminPageState extends State<FantasyAdminPage> {
  String playerName = '';
  String teamName = '';
  int points = 0;
  DateTime selectedDate = DateTime.now();
  List<dynamic> rankings = [];

  @override
  void initState() {
    super.initState();
    fetchRankings();
  }

  // Fetch rankings from the API
  Future<void> fetchRankings() async {
    try {
      var response = await http.get(Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-all-fantasy-scores'));
      if (response.statusCode == 200) {
        setState(() {
          rankings = jsonDecode(response.body);
        });
      } else {
        print('Failed to load rankings');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Submit the new fantasy player details
  Future<void> addFantasyPlayer() async {
    if (playerName.isEmpty || teamName.isEmpty || points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      var response = await http.post(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/add-fantasy-player'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'player': playerName,
          'teamName': teamName,
          'points': points,
          'date': formattedDate
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fantasy player added successfully')),
        );
        setState(() {
          playerName = '';
          teamName = '';
          points = 0;
          selectedDate = DateTime.now();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add player')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Date Picker for the date input
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy Admin Page - ${widget.email}'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Section
            _buildFormSection(),
            SizedBox(height: 20),
            // Ranking Table Section
            _buildRankingTableSection(),
          ],
        ),
      ),
    );
  }

  // Build the form section with input fields
  Widget _buildFormSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Fantasy Player',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Player Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => playerName = value),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => teamName = value),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Points',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  setState(() => points = int.tryParse(value) ?? 0),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addFantasyPlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Center(
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the ranking table section
  Widget _buildRankingTableSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Todays Fantasy Rankings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            rankings.isNotEmpty
                ? Container(
                    height:
                        400, // Limit the height of the table for scrollability
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: rankings.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${rankings[index]['rank']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green.shade700,
                              ),
                              title: Text(
                                rankings[index]['email'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Total Points: ${rankings[index]['totalPoint']}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.info, color: Colors.blue),
                                onPressed: () {
                                  // Add functionality if needed (e.g., show player details)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Details of ${rankings[index]['email']}')),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No rankings available'),
                  ),
          ],
        ),
      ),
    );
  }
}
