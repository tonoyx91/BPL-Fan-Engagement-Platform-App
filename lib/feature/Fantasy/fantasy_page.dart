import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BPLFantasyLeaguePage extends StatefulWidget {
  final String email;

  const BPLFantasyLeaguePage({Key? key, required this.email}) : super(key: key);

  @override
  _BPLFantasyLeaguePageState createState() => _BPLFantasyLeaguePageState();
}

class _BPLFantasyLeaguePageState extends State<BPLFantasyLeaguePage> {
  List<String> selectedPlayers = [];
  String teamName = "";
  int matchdayScore = 0;
  int totalScore = 0;
  int ranking = 0;
  String team1Name = '';
  String team2Name = '';
  List<String> team1Players = [];
  List<String> team2Players = [];
  bool canCreateTeam = true;
  Duration countdownDuration = Duration();
  Timer? countdownTimer;
  late DateTime nextDay;

  @override
  void initState() {
    super.initState();
    nextDay = _getNextDay();
    _initializeCountdown();
    _checkIfTeamCreated(); // Check if the team is already created
    _fetchUserScoreAndRanking();
    _fetchFixtureAndPlayers();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  DateTime _getNextDay() {
    return DateTime.now().add(Duration(days: 1)).toUtc();
  }

  void _initializeCountdown() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setState(() {
      countdownDuration = endOfDay.difference(now);
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownDuration.inSeconds > 0) {
          countdownDuration = countdownDuration - Duration(seconds: 1);
        } else {
          timer.cancel();
          _initializeCountdown(); // Reset the countdown after the day ends
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours}:${minutes}:${seconds}';
  }

  Future<void> _fetchUserScoreAndRanking() async {
    try {
      String todayFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var scoreResponse = await http.get(Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-user-score?email=${widget.email}'));

      if (scoreResponse.statusCode == 200) {
        var scoreData = jsonDecode(scoreResponse.body);
        setState(() {
          matchdayScore = scoreData['point'];
          totalScore = scoreData['totalPoint'];
          teamName = scoreData['teamname'];
        });
      }

      var rankingResponse = await http.get(Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-user-ranking?email=${widget.email}'));
      if (rankingResponse.statusCode == 200) {
        var rankingData = jsonDecode(rankingResponse.body);
        setState(() {
          ranking = rankingData['rank'];
        });
      }
    } catch (error) {
      print('Error fetching user score and ranking: $error');
    }
  }

  Future<void> _fetchFixtureAndPlayers() async {
    try {
      var fixtureResponse = await http.get(Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-next-day-fixture'));

      if (fixtureResponse.statusCode == 200) {
        var fixtureData = jsonDecode(fixtureResponse.body);
        setState(() {
          team1Name = fixtureData['team1'];
          team2Name = fixtureData['team2'];
        });

        var team1Response = await http.get(Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-players/$team1Name'));
        var team2Response = await http.get(Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-players/$team2Name'));

        if (team1Response.statusCode == 200 &&
            team2Response.statusCode == 200) {
          setState(() {
            team1Players =
                List<String>.from(jsonDecode(team1Response.body)['players']);
            team2Players =
                List<String>.from(jsonDecode(team2Response.body)['players']);
          });
        } else {
          print("Failed to fetch players for one or both teams.");
        }
      } else {
        print("Failed to fetch the fixture.");
      }
    } catch (error) {
      print('Error fetching fixture or players: $error');
    }
  }

  Future<void> _checkIfTeamCreated() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/check-next-day-team?email=${widget.email}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          canCreateTeam = false;
        });
      }
    } catch (error) {
      print('Error checking next day team: $error');
      setState(() {
        canCreateTeam = true;
      });
    }
  }

  Future<void> _saveFantasyTeam() async {
    if (selectedPlayers.length != 11 || teamName.isEmpty) {
      Get.snackbar('Error', 'Please select 11 players and enter a team name.');
      return;
    }

    try {
      String nextDayFormatted = DateFormat('yyyy-MM-dd').format(nextDay);
      var response = await http.post(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/add-fantasy-team'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'teamname': teamName,
          'players': selectedPlayers,
          'date': nextDayFormatted
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Fantasy team saved for $nextDayFormatted.');
      } else {
        Get.snackbar('Error', 'Failed to save fantasy team.');
      }
    } catch (error) {
      print('Error saving fantasy team: $error');
      Get.snackbar('Error', 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BPL Fantasy League 2024"),
        backgroundColor: const Color.fromARGB(255, 11, 79, 14),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTeamSelectionSection(),
            _buildCountdownTimer(),
            if (canCreateTeam) ...[
              _buildTeamNameInput(), // Adding the team name input here
              _buildPlayerSelection(),
              _buildSaveButton(),
            ] else ...[
              _buildTeamAlreadyCreatedMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSelectionSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 10, // Space between cards horizontally
        runSpacing: 10, // Space between cards vertically
        alignment: WrapAlignment.center,
        children: [
          _buildScoreCard('Team Name', teamName, Colors.greenAccent.shade400),
          _buildScoreCard('Matchday',
              '${DateFormat('yyyy-MM-dd').format(nextDay)}', Colors.blueAccent),
          _buildScoreCard(
              'Matchday Score', '$matchdayScore', Colors.orangeAccent),
          _buildScoreCard('Total Score', '$totalScore', Colors.purpleAccent),
          _buildScoreCard('Ranking', '#$ranking', Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, String value, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.lightBlue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: 'Enter your Fantasy Team Name',
          hintText: 'e.g., Thunderbolts XI',
          labelStyle:
              TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
        onChanged: (value) {
          setState(() {
            teamName = value;
          });
        },
      ),
    );
  }

  Widget _buildCountdownTimer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.yellow.shade700.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.black, size: 30),
          const SizedBox(width: 10),
          Text('Time Remaining: ${_formatDuration(countdownDuration)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPlayerSelection() {
    return Column(
      children: [
        Text('Choose Your Fantasy Team',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Team 1: $team1Name',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  _buildPlayerChips(team1Players),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Team 2: $team2Name',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  _buildPlayerChips(team2Players),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerChips(List<String> players) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: players.map((player) {
        final isSelected = selectedPlayers.contains(player);
        return FilterChip(
          label: Text(player,
              style:
                  TextStyle(color: isSelected ? Colors.white : Colors.black)),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected && selectedPlayers.length < 11) {
                selectedPlayers.add(player);
              } else {
                selectedPlayers.remove(player);
              }
            });
          },
          backgroundColor: Colors.grey.shade300,
          selectedColor: Colors.greenAccent.shade700,
          shape: StadiumBorder(
              side: BorderSide(
                  color: isSelected ? Colors.green : Colors.grey, width: 2)),
        );
      }).toList(),
    );
  }

  Widget _buildTeamAlreadyCreatedMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'You already selected your fantasy team for tomorrow. Come back tomorrow to select again!',
        style: TextStyle(
            fontSize: 20, color: Colors.redAccent, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _saveFantasyTeam,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
        child: const Text('Save Fantasy Team'),
      ),
    );
  }
}
