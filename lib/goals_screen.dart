import 'package:flutter/material.dart';

class Goals extends StatefulWidget {
  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<String> goalCards = [];
  bool _isDeleting = false;

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
                        goalCards.add('');
                      });
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
                    isDeleting: _isDeleting,
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

class GoalCardWidget extends StatefulWidget {
  final String text;
  final Function(String) onTextChanged;
  final VoidCallback onDelete;
  final bool isDeleting;

  GoalCardWidget({
    required this.text,
    required this.onTextChanged,
    required this.onDelete,
    required this.isDeleting,
  });

  @override
  _GoalCardWidgetState createState() => _GoalCardWidgetState();
}

class _GoalCardWidgetState extends State<GoalCardWidget> {
  bool _checked = false;
  late TextEditingController _editingController;
  bool _isEditing = false;

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

  void _saveChanges() {
    widget.onTextChanged(_editingController.text);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  value: _checked,
                  onChanged: (value) {
                    setState(() {
                      _checked = value!;
                    });
                  },
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
                            decoration:
                                _checked ? TextDecoration.lineThrough : null,
                          ),
                          child: Text(widget.text),
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
          ],
        ),
      ),
    );
  }
}
