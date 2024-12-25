import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PointsTableAdminPage extends StatefulWidget {
  final String email; // Email of the logged-in user

  const PointsTableAdminPage({super.key, required this.email});

  @override
  _PointsTableAdminPageState createState() => _PointsTableAdminPageState();
}

class _PointsTableAdminPageState extends State<PointsTableAdminPage> {
  final _formKey = GlobalKey<FormState>();

  // List of predefined teams
  final List<String> teams = [
    "Dhaka Dominators",
    "Comilla Victorians",
    "Chattogram Challengers",
    "Khulna Tigers",
    "Rangpur Riders",
    "Sylhet Sixers"
  ];

  String? selectedTeam; // Selected team from the dropdown menu
  int totalMatches = 0;
  int wins = 0;
  int losses = 0;
  int draws = 0;
  int points = 0;
  double netRunRate = 0.0;

  bool isLoading = false;
  List<dynamic> pointsTable = []; // List to hold points table data
  bool isFetchingTable = true; // To show loading spinner while fetching data

  @override
  void initState() {
    super.initState();
    fetchPointsTable(); // Fetch points table on init
  }

  // Function to fetch the points table from the API
  Future<void> fetchPointsTable() async {
    final url = Uri.parse(
        'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-pointstable');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          pointsTable = fetchedData;
          isFetchingTable = false;
        });
      } else {
        setState(() {
          isFetchingTable = false;
        });
      }
    } catch (error) {
      setState(() {
        isFetchingTable = false;
      });
    }
  }

  // Function to call PUT API to update points table
  Future<void> updatePointsTable() async {
    if (selectedTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a team!'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/update-pointstable/$selectedTeam');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'totalMatches': totalMatches,
        'win': wins,
        'losses': losses,
        'draw': draws,
        'points': points,
        'netRunRate': netRunRate,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Points table updated successfully!'),
        ),
      );
      fetchPointsTable(); // Refresh the table after update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update points table!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Points Table Admin",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Update Points Table",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: DropdownButtonFormField<String>(
                  value: selectedTeam,
                  decoration: InputDecoration(
                    labelText: "Select Team",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(color: Color(0xFF607D8B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF607D8B)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF0288D1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: teams.map((team) {
                    return DropdownMenuItem(
                      value: team,
                      child: Text(
                        team,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTeam = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a team';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              buildNumberField(
                  "Total Matches", (value) => totalMatches = int.parse(value)),
              const SizedBox(height: 10),
              buildNumberField("Wins", (value) => wins = int.parse(value)),
              const SizedBox(height: 10),
              buildNumberField("Losses", (value) => losses = int.parse(value)),
              const SizedBox(height: 10),
              buildNumberField("Draws", (value) => draws = int.parse(value)),
              const SizedBox(height: 10),
              buildNumberField("Points", (value) => points = int.parse(value)),
              const SizedBox(height: 10),
              buildNumberField(
                  "Net Run Rate", (value) => netRunRate = double.parse(value)),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            _formKey.currentState?.save(); // Save form values
                            updatePointsTable();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: const Color(0xFF0288D1),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
              const SizedBox(height: 20),
              isFetchingTable
                  ? const Center(child: CircularProgressIndicator())
                  : buildPointsTable(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create number input fields
  TextFormField buildNumberField(String label, Function(String) onSaved) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Color(0xFF37474F)),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF607D8B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF607D8B)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0288D1)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: (newValue) => onSaved(newValue!),
      onChanged: (newValue) => onSaved(newValue),
    );
  }

  // Function to build the points table UI
  Widget buildPointsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.teal[800]!,
          ),
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
          rows: pointsTable.map((team) {
            return DataRow(
              cells: [
                DataCell(Text(team['teamName'] ?? '',
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text(team['totalMatches'].toString(),
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text(team['win'].toString(),
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text(team['losses'].toString(),
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text(team['draw'].toString(),
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text(team['points'].toString(),
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text(team['netRunRate'].toString(),
                    style: const TextStyle(color: Colors.white))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
