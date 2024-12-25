import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizPage extends StatefulWidget {
  final String email;
  const QuizPage({super.key, required this.email});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  int _totalTimeTaken = 0; // Track the total time taken for the quiz
  bool _quizStarted = false;
  bool _alreadyPlayedToday = false; // To check if user played today
  int? _previousScore; // Store the previous score if played today
  String? _previousDate;
  String? _timeTaken;
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which one is the Biggest Franchise League?',
      'options': ['IPL', 'BPL', 'PSL', 'CPL'],
      'answer': 'BPL',
    },
    {
      'question': 'Who is the highest wicket taker of last BPL?',
      'options': ['Russel', 'Miraz', 'Mashrafee', 'Shakib'],
      'answer': 'Mashrafee',
    },
    {
      'question': 'When was BPL first started?',
      'options': ['2013', '2012', '2011', '2010'],
      'answer': '2012',
    },
    {
      'question': 'Which team won the most BPL trophies?',
      'options': [
        'Comilla Victorians',
        'Fortune Barishal',
        'Dhaka Dominators',
        'Chattagram Challengers'
      ],
      'answer': 'Comilla Victorians',
    },
    {
      'question': 'How many stadiums are in BPL?',
      'options': ['3', '2', '1', '4'],
      'answer': '3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkIfPlayedToday(); // Check if user played today on page load
  }

  void _checkIfPlayedToday() async {
    // Get today's date in YYYY-MM-DD format
    final today = DateTime.now().toString().split(' ')[0];

    // Call the API to check if user has played the quiz today
    final response = await http.get(
      Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/check-quizscore?email=${widget.email}&date=$today'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['quizScore'] != null) {
        setState(() {
          _alreadyPlayedToday = true;
          _previousScore = data['quizScore']['score'];
          _previousDate = data['quizScore']['date'];
          _timeTaken = data['quizScore']['time'];
        });
      }
    } else if (response.statusCode == 404) {
      // No quiz score found for today, so user can play the quiz
      setState(() {
        _alreadyPlayedToday = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching quiz data')),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        _totalTimeTaken++; // Increment total time taken
        if (_timeLeft == 0) {
          _showResults();
        }
      });
    });
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _startTimer();
    });
  }

  void _answerQuestion(String selectedOption) {
    if (_timeLeft > 0) {
      if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
        _score++;
      }
      setState(() {
        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
          _timeLeft = 30; // Reset timer for each question
        } else {
          _showResults();
        }
      });
    }
  }

  void _showResults() async {
    _timer.cancel();

    // Store the score and total time taken in the database
    await http.post(
      Uri.parse(
          'https://bpl-fan-engagement-platform-app.onrender.com/api/auth/store-quizscore'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'score': _score,
        'date': DateTime.now().toString().split(' ')[0],
        'time': _totalTimeTaken.toString(), // Store total time taken
      }),
    );

    setState(() {
      _quizStarted = false;
      _alreadyPlayedToday = true;
      _previousScore = _score;
      _timeTaken = _totalTimeTaken.toString();
      _previousDate = DateTime.now().toString().split(' ')[0];
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Play Quiz',
          style: TextStyle(fontSize: 24, color: Colors.yellow),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () =>
              Navigator.of(context).pop(), // Back button to homepage
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _alreadyPlayedToday
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'You cannot play today, come back tomorrow!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _previousDate != null
                      ? Column(
                          children: [
                            _buildInfoCard('Date', _previousDate!),
                            _buildInfoCard('Time Taken', '$_timeTaken seconds'),
                            _buildInfoCard('Score',
                                '$_previousScore out of ${_questions.length}'),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), // Back button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Homepage',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              )
            : _quizStarted
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Time Left: $_timeLeft seconds',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.red),
                            ),
                            Text(
                              'Score: $_score',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Question ${_currentQuestionIndex + 1} out of ${_questions.length}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              _buildQuestionBox(
                                  _questions[_currentQuestionIndex]
                                      ['question']),
                              const SizedBox(height: 20),
                              ..._questions[_currentQuestionIndex]['options']
                                  .map((option) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ElevatedButton(
                                    onPressed: () => _answerQuestion(option),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      option,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
      ),
    );
  }

  // Widget to build a beautiful question box
  Widget _buildQuestionBox(String question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: Text(
        question,
        style: const TextStyle(fontSize: 22, color: Colors.yellow),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget to build information card
  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.yellow),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
