import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Goals extends StatefulWidget {
  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Goal> goalCards = [];
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadGoals(); // Load goals when the widget initializes
  }

  // Function to save goals to SharedPreferences
  void _saveGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> goalsJson = Goal.goalsToJson(goalCards);
    await prefs.setStringList('goals', goalsJson);
  }

  // Function to load goals from SharedPreferences
  void _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? goalsJson = prefs.getStringList('goals');
    if (goalsJson != null) {
      setState(() {
        goalCards = Goal.goalsFromJson(goalsJson);
        print('Loaded ${goalCards.length} goals'); // Debug print
      });
    } else {
      print('No goals found in SharedPreferences'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
        actions: [
          IconButton(
            icon: Icon(_isDeleting ? Icons.close : Icons.delete),
            onPressed: () {
              setState(() {
                _isDeleting = !_isDeleting;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isDeleting)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tap "X" to delete a goal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: goalCards.length + 1,
              itemBuilder: (context, index) {
                if (index == goalCards.length) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        goalCards.add(Goal(
                          title: '',
                          created: DateTime.now(),
                          deadline: DateTime.now(), // Default deadline
                        ));
                      });
                      _saveGoals(); // Save goals after adding a new one
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
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
                    goal: goalCards[index],
                    onTextChanged: (newText) {
                      setState(() {
                        goalCards[index].title = newText;
                      });
                      _saveGoals(); // Save goals after editing a title
                    },
                    onDelete: () {
                      setState(() {
                        goalCards.removeAt(index);
                      });
                      _saveGoals(); // Save goals after deleting one
                    },
                    isDeleting: _isDeleting,
                    onSave: _saveGoals, // Pass the _saveGoals function
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Goal {
  String title;
  DateTime created;
  DateTime deadline;
  bool isChecked; // New property to store checkbox status

  Goal({
    required this.title,
    required this.created,
    required this.deadline,
    this.isChecked = false, // Default value is false
  });

  // Convert list of goals to JSON
  static List<String> goalsToJson(List<Goal> goals) {
    return goals.map((goal) => json.encode(goal.toJson())).toList();
  }

  // Convert JSON to list of goals
  static List<Goal> goalsFromJson(List<String> jsonList) {
    return jsonList.map((json) => Goal.fromJson(jsonDecode(json))).toList();
  }

  // Convert goal to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'created': created.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'isChecked': isChecked,
    };
  }

  // Convert JSON to goal
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      title: json['title'],
      created: DateTime.parse(json['created']),
      deadline: DateTime.parse(json['deadline']),
      isChecked: json['isChecked'] ?? false, // Set default value if not present
    );
  }
}

class GoalCardWidget extends StatefulWidget {
  final Goal goal;
  final Function(String) onTextChanged;
  final VoidCallback onDelete;
  final bool isDeleting;
  final Function() onSave;

  GoalCardWidget({
    required this.goal,
    required this.onTextChanged,
    required this.onDelete,
    required this.isDeleting,
    required this.onSave,
  });

  @override
  _GoalCardWidgetState createState() => _GoalCardWidgetState();
}

class _GoalCardWidgetState extends State<GoalCardWidget> {
  late TextEditingController _editingController;
  late TextEditingController _dateController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.goal.title);
    _dateController = TextEditingController(
      text:
          "${widget.goal.deadline.day}/${widget.goal.deadline.month}/${widget.goal.deadline.year}",
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.onTextChanged(_editingController.text);
    widget.onSave(); // Call the onSave function here
    setState(() {
      _isEditing = false;
    });
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.goal.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.goal.deadline) {
      setState(() {
        widget.goal.deadline = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
      widget.onSave(); // Call the onSave function here
    }
  }

  void _toggleCheckbox(bool? value) {
    if (value != null) {
      setState(() {
        widget.goal.isChecked = value;
        widget.onSave(); // Call the onSave function here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created: ${widget.goal.created.day}/${widget.goal.created.month}/${widget.goal.created.year}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (_isEditing)
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: _saveChanges,
                  ),
                if (widget.isDeleting)
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: widget.onDelete,
                  ),
                Checkbox(
                  value: widget.goal.isChecked,
                  onChanged: _toggleCheckbox,
                ),
                Expanded(
                  child: _isEditing
                      ? TextFormField(
                          controller: _editingController,
                          autofocus: true,
                          onEditingComplete: _saveChanges,
                        )
                      : AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 300),
                          style: TextStyle(
                            color:
                                Colors.black, // Specify the desired text color
                            decoration: widget.goal.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          child: Text(widget.goal.title),
                        ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('Deadline: '),
                Expanded(
                  child: _isEditing
                      ? GestureDetector(
                          onTap: _showDatePicker,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                            ),
                          ),
                        )
                      : Text(
                          "${widget.goal.deadline.day}/${widget.goal.deadline.month}/${widget.goal.deadline.year}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
