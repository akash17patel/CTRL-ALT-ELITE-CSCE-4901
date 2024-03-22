////////////////////////////////////////

import 'db_helper.dart'; // Import your DBHelper class
import 'package:flutter/material.dart'; // Package for building UIs in Flutter
//import 'db_helper.dart'; // Import database helper class

// Goals widget, a StatelessWidget representing the goals of the application
abstract class Goals extends StatelessWidget {
  // final dbHelper = DBHelper(); // Create an instance of database helper

  //defining method createState inside goals class
  _GoalsState createState() =>
      _GoalsState(); //_ indicates that this state class is private to its file
}

class _GoalsState extends State<TextField> {
  List<String> goalCards = []; //initializing list as empty to store goal cards
  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //dbHelper.getData().then((data) {
    // Print data fetched from database
    //   print(data);
    // });

    // Scaffold widget
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'), // Text displayed in the app bar
      ),
      body: ListView.builder(
        //ListView.builder(widget) creates items on demand, used for efficiently creating scrollable lists or items grids.
        //itemcount and itemBuilder are properties of ListView.builder
        //itemCOunt determines the number of items in ListView
        itemCount: goalCards.length +
            1, // +1 to add new goal card, and number of items in list = number of cards created and saved
        // itemBuilder =callback function to build listview children dynammically
        itemBuilder: (context, index) {
          if (index == goalCards.length) {
            // Make the button that adds new card to goals i.e "Add new goal"
            return GestureDetector(
              // Widget that detects gestures e.g tap
              onTap: () {
///////////////////////////----------------added for db
                // Get the entered goal
                String goal = _goalController.text.trim();
                // Call the method to insert data into the database
                DBHelper().insertData({'goal': goal});
                // Clear the text field after insertion
                _goalController.clear();

                //update to show addition of a goal card
                setState(() {
                  goalCards.add(goal);
                }); /////////////////////////////////
              },
              child: Container(
                padding:
                    EdgeInsets.all(16), //insets = distance from edges(of box)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add), // to add plus sign icon '+'
                    SizedBox(width: 8),
                    Text('Add new goal'),
                  ],
                ),
              ),
            );
          } else {
            return GoalCardWidget(
              text: goalCards[index],
              onDelete: () {
                //allows deletion of cards by users
                setState(() {
                  //updates state
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
  // onDelete allows users to delete any card from Goals(GoalCardWIdget)
  final VoidCallback
      onDelete; // callback funtion that returns void and takes in no arguments
  // required this.text = when user creates a card for goals, they must add a value for this parameter
  GoalCardWidget(
      {required this.text,
      required this.onDelete}); //onDelete is called when delete action is performed for this item
  //defining createState method
  @override
  _GoalCardWidgetState createState() => _GoalCardWidgetState();
}

class _GoalCardWidgetState extends State<GoalCardWidget> {
  bool _editing =
      false; // currently not in editing state   ,note: '_' represents 'private variable' specific to library it is in
  bool _checked = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    // declararing method
    _editingController
        .dispose(); //disposes objects of TextEditingController when they are not needed.
    super
        .dispose(); // superclass method called to guarantee that cleanup activities specified in superclass are carried out too.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16), //adds padding to edges of card
        //card aligned at left of a vertical column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // puts children in horizontal row
            Row(
              children: [
                //adding widget "checkbox"  to row
                Checkbox(
                  value: _checked,
                  onChanged: (value) {
                    // function called when value of the checkbox is changed
                    //updates _checked to new value
                    setState(() {
                      _checked = value!;
                    });
                  },
                ),

                Expanded(
                  // if the edit is in process, text field is shown to user
                  child: _editing
                      ? TextField(
                          controller: _editingController,
                        )
                      // text widget is shown if not editing
                      : Text(widget.text),
                ),
                // adding save and edit icons to a card
                IconButton(
                  icon: Icon(_editing ? Icons.save : Icons.edit),
                  onPressed: () {
                    setState(() {
                      // checking if user is editing the card value/text and assigning text value of _editingController to 'text' property
                      if (_editing) {
                        _editingController.text;
                      }
                      _editing =
                          !_editing; // allows switching between editing and viewing state of card
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete), //delete icon
                  onPressed:
                      widget.onDelete, //deletes object when delete is pressed
                ),
              ],
            ),

            if (!_editing) // if widget is not being edited
              GestureDetector(
                // detects tap gesture by user to toggle value of '_checked' container
                onTap: () {
                  setState(() {
                    _checked = !_checked;
                  });
                },

                // checkbox visual representation
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // when _checked = true, checkmark icon appears; else, nothing is there (i.e null).
                  child: _checked ? Icon(Icons.check) : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
      //home: Goals(),
      ));
}
