import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminQuizPage extends StatefulWidget {
  const AdminQuizPage({super.key, required String email});

  @override
  _AdminQuizPageState createState() => _AdminQuizPageState();
}

class _AdminQuizPageState extends State<AdminQuizPage> {
  List<Map<String, dynamic>> _quizScores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizScores();
  }

  void _fetchQuizScores() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/get-all-quizscores'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> filteredScores = data
            .map((score) => {
                  'email': score['email'],
                  'score': score['score'],
                  'time': int.parse(score['time']),
                })
            .toList();

        filteredScores.sort((a, b) {
          if (a['score'] != b['score']) {
            return b['score'].compareTo(a['score']); // Sort by score descending
          }
          return a['time'].compareTo(
              b['time']); // Sort by time ascending if score is the same
        });

        setState(() {
          _quizScores = filteredScores;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching quiz scores')),
        );
      }
    } catch (error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching quiz scores')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[700]!, Colors.black],
          ),
        ),
        child: Center(
          child: _loading
              ? const CircularProgressIndicator(color: Colors.amberAccent)
              : _quizScores.isEmpty
                  ? const Text(
                      'No quiz results available for today',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '📊 Todays Quiz Result',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          _buildRankingTable(),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildRankingTable() {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 20,
                headingTextStyle: const TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                dataRowHeight: 60,
                decoration: BoxDecoration(
                  color: Colors.purple[900]?.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 8,
                    ),
                  ],
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Rank',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Score',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time (Seconds)',
                    ),
                  ),
                ],
                rows: _quizScores
                    .asMap()
                    .entries
                    .map(
                      (entry) => DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (entry.key % 2 == 0) {
                              return Colors.purple.withOpacity(0.2);
                            }
                            return Colors.black.withOpacity(0.1);
                          },
                        ),
                        cells: [
                          DataCell(Text(
                            '#${entry.key + 1}', // Rank
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                          DataCell(Text(
                            entry.value['email'],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                          DataCell(Text(
                            entry.value['score'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                          DataCell(Text(
                            entry.value['time'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
