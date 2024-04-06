import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mind_lift/services/database.dart';
import 'package:table_calendar/table_calendar.dart';

class EmotionHistory extends StatefulWidget {
  @override
  _EmotionHistoryState createState() => _EmotionHistoryState();
}

class _EmotionHistoryState extends State<EmotionHistory> {
  @override
  void initState() {
    super.initState();
    _fetchEmotionsForSelectedDay();
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _emotionHistory = [];

  void _onEmotionSelected(String emotion) async {
    DateTime now = DateTime.now();
    // Create a new DateTime object representing today, with only year, month, and day parts
   
    //DateTime today = DateTime(now.year, now.month, now.day);
    
    // Ensure _selectedDay is also stripped of any time part

    DateTime selectedDate = _selectedDay != null
        ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, _selectedDay!.hour, _selectedDay!.minute, _selectedDay!.second)
        : now;        

    // Now check if the selectedDate is today    
    if (selectedDate.day == DateTime.now().day) {
      // If the selected date is today, directly add the emotion without showing a prompt
      await MindliftDatabase.instance.insertEmotion(emotion, selectedDate);
    } else {
      // If the selected date is not today, show the prompt
      bool confirmed = await _showAddEmotionConfirmationDialog();
      if (!confirmed) {
        return; // Exit if the user cancels the action
      }

      // Proceed to add the emotion to the database
      await MindliftDatabase.instance.insertEmotion(emotion, selectedDate);
    }

    // Refresh the emotions
    _fetchEmotionsForSelectedDay();
  }

  Future<bool> _showAddEmotionConfirmationDialog() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Action'),
            content: Text(
                'Are you sure you want to add an emotion to a different day?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () =>
                    Navigator.of(context).pop(false), // Return false on cancel
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context)
                    .pop(true), // Return true on confirmation
              ),
            ],
          ),
        )) ??
        false; // Return false if the dialog is dismissed
  }

  void _fetchEmotionsForSelectedDay() async {
    if (_selectedDay != null) {
      List<Map<String, dynamic>> fetchedEmotions =
          await MindliftDatabase.instance.fetchEmotionsForDate(_selectedDay!);

      // List<String> emotionList = fetchedEmotions
      //     .map((record) =>
      //         '${record['emotion']} - ${record['timestamp'].split('T')[0]}')
      //     .toList();

           List<String> emotionList = fetchedEmotions
          .map((record) =>
              '${record['emotion']} - ${DateFormat('yyyy-MM-dd hh:mm a').format((DateTime.parse(record['timestamp'])))}')
          .toList();

      setState(() {
        _emotionHistory = emotionList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime lastSelectableDay = today;

    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion History'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: today.subtract(Duration(days: 3000)),
            lastDay: lastSelectableDay,
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {

                DateTime s = DateTime.now();

                _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, s.hour, s.minute, s.second);

               // _selectedDay = selectedDay;
                
                _focusedDay = focusedDay;
              });
              _fetchEmotionsForSelectedDay();
            },
            calendarStyle:const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 80, 193, 0),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 119, 0, 255),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle:const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _emotionHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_emotionHistory[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _onEmotionSelected('😃');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onEmotionSelected('😊');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onEmotionSelected('😐');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                    ),
                    child: Icon(
                      Icons.sentiment_neutral,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onEmotionSelected('😟');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onEmotionSelected('😞');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: Icon(
                      Icons.sentiment_very_dissatisfied_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
