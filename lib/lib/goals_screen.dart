/*import 'package:flutter/material.dart';
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
*/

import 'package:flutter/material.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<String> goalCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: ListView.builder(
        itemCount: goalCards.length + 1,
        itemBuilder: (context, index) {
          if (index == goalCards.length) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  goalCards.add('');
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add new goal'),
                  ],
                ),
              ),
            );
          } else {
            return GoalCardWidget(
              text: goalCards[index],
              onTextChanged: (newText) {
                setState(() {
                  goalCards[index] = newText;
                });
              },
              onDelete: () {
                setState(() {
                  goalCards.removeAt(index);
                });
              },
            );
          }
        },
      ),
    );
  }
}

class GoalCardWidget extends StatefulWidget {
  final String text;
  final Function(String) onTextChanged;
  final VoidCallback onDelete;

  const GoalCardWidget({super.key, 
    required this.text,
    required this.onTextChanged,
    required this.onDelete,
  });

  @override
  _GoalCardWidgetState createState() => _GoalCardWidgetState();
}

class _GoalCardWidgetState extends State<GoalCardWidget> {
  bool _checked = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _checked,
                  onChanged: (value) {
                    setState(() {
                      _checked = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(widget.text),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      // Implement edit functionality here
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
