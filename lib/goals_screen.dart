import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<String> reminders = []; // List of reminders or goals
  String selectedMood = ''; // Track the selected mood

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: Column(
        children: [
          // Mood Icons
          Text('Rate your mood', style: TextStyle(fontSize: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.sentiment_very_dissatisfied, size: 48),
                onPressed: () {
                  setState(() {
                    selectedMood = 'Very Dissatisfied';
                  });
                },
                color: selectedMood == 'Very Dissatisfied'
                    ? const Color.fromARGB(255, 243, 33, 33)
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.sentiment_dissatisfied, size: 48),
                onPressed: () {
                  setState(() {
                    selectedMood = 'Dissatisfied';
                  });
                },
                color: selectedMood == 'Dissatisfied'
                    ? const Color.fromARGB(255, 243, 191, 33)
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.sentiment_satisfied, size: 48),
                onPressed: () {
                  setState(() {
                    selectedMood = 'Satisfied';
                  });
                },
                color: selectedMood == 'Satisfied'
                    ? const Color.fromARGB(255, 32, 142, 231)
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.sentiment_very_satisfied, size: 48),
                onPressed: () {
                  setState(() {
                    selectedMood = 'Very Satisfied';
                  });
                },
                color: selectedMood == 'Very Satisfied'
                    ? Color.fromARGB(255, 33, 243, 33)
                    : null,
              ),
            ],
          ),

          // Section break for Mood Reflection
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Mood Reflection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Progress Chart
          Expanded(
            child: LineChart(
              LineChartData(
                  // Define chart data and appearance here
                  ),
            ),
          ),

          // Goals Reminder
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reminders[index], style: TextStyle(fontSize: 20)),
                  // Add logic for checking off reminders or other actions
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
