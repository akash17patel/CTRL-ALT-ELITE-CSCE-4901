import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';

class ConversationHistoryScreen extends StatefulWidget {
  @override
  _ConversationHistoryScreenState createState() => _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState extends State<ConversationHistoryScreen> {
  List<Map<String, dynamic>> _chatMessages = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation History')),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(
            child: _buildChatMessages(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            DateTime now = DateTime.now();
            _focusedDay = DateTime(now.year, now.month, now.day);
            _selectedDay = _focusedDay;
            _loadChatMessages(_selectedDay!);
          }),
          child: Text('Today'),
        ),
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2023, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _loadChatMessages(selectedDay);
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      itemCount: _chatMessages.length,
      itemBuilder: (context, index) {
        final message = _chatMessages[index];
        return Container(
          color: message['sender'] == 'User' ? Colors.blue : Colors.green,
          child: ChatMessageWidget(
            sender: message['sender'],
            text: message['text'],
            timestamp: message['timestamp'],
          ),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        );
      },
    );
  }

  void _loadChatMessages(DateTime selectedDate) async {
    String formattedDate = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    //print("Selected date: $formattedDate"); // Debug print

    List<Map<String, dynamic>> chatMessages =
    await DatabaseHelper.instance.getChatMessagesForDate(formattedDate);
    //print("Retrieved messages: $chatMessages"); // Debug print

    setState(() {
      _chatMessages = chatMessages;
    });
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final String timestamp;

  const ChatMessageWidget({
    Key? key,
    required this.sender,
    required this.text,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(text)),
          Text(_formatTimestamp(timestamp),
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      subtitle: Text(sender),
    );
  }

  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

bool isSameDay(DateTime? dayA, DateTime dayB) {
  return dayA?.year == dayB.year &&
      dayA?.month == dayB.month &&
      dayA?.day == dayB.day;
}