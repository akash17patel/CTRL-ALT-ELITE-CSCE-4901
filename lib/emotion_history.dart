import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EmotionHistory extends StatefulWidget {
  @override
  _EmotionHistoryState createState() => _EmotionHistoryState();
}

class _EmotionHistoryState extends State<EmotionHistory> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _emotionHistory = [];

  void _onEmotionSelected(String emotion) {
    setState(() {
      _emotionHistory.add('$emotion - ${DateFormat.yMd().format(_focusedDay)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion History'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay:DateTime.now().subtract(Duration(days:3000)) ,
            lastDay: DateTime.now().add (Duration(days:3000)),
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
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
                      Icons.sentiment_very_satisfied,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onEmotionSelected('😃');
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
            
              ]),
          )]));}}