import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'services/database.dart';

class ConversationHistoryScreen extends StatefulWidget {
  @override
  _ConversationHistoryScreenState createState() =>
      _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState extends State<ConversationHistoryScreen> {
  List<Map<String, dynamic>> _chatMessages = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    _selectedDay = DateTime.now();
    _loadChatMessages(_selectedDay!);
    
    super.initState();
  }

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
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime.utc(
        now.year - 1, now.month, now.day); // Example: Last year from today
    DateTime lastDay = DateTime.utc(
        now.year + 1, now.month, now.day); // Example: Next year from today

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            _focusedDay = DateTime(now.year, now.month, now.day);
            _selectedDay = _focusedDay;
            _loadChatMessages(_selectedDay!);
          }),
          child: Text('Today'),
        ),
        TableCalendar(
          firstDay: firstDay,
          lastDay: lastDay,
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
    if (_chatMessages.isEmpty) {
      return Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      );
    }

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
    String formattedDate =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    print("Loading messages for date: $formattedDate"); // Debugging line

    List<Map<String, dynamic>> chatMessages =
    await MindliftDatabase.instance.getChatMessagesForDate(formattedDate);

    print("Retrieved messages: $chatMessages"); // Debugging line

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
