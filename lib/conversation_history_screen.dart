import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';

class ConversationHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation History')),
      body: Column(
        children: [
          _buildCalendar(),
          SizedBox(height: 16),
          Expanded(
            child: _buildChatMessages(), // Add the chat messages widget
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableBasicsExample(onDateSelected:
        (DateTime selectedDate, List<Map<String, dynamic>> chatMessages) {
      // Handle the selected date and received messages
      _loadChatMessages(selectedDate, chatMessages);
    });
  }

  Widget _buildChatMessages() {
    final chatMessages = _TableBasicsExampleState().getChatMessages();
    // Placeholder for the chat messages widget
    return Center(
      child: Text(
          'Select a date to load chat messages. Total messages: ${_TableBasicsExampleState().chatMessages.length}'),
    );
  }

  void _loadChatMessages(
      DateTime selectedDate, List<Map<String, dynamic>> chatMessages) async {
    final formattedDate = selectedDate.toUtc().toIso8601String();
    List<Map<String, dynamic>> chatMessages =
        await DatabaseHelper.instance.getChatMessagesForDate(formattedDate);
    // Process and display the retrieved messages as needed
    _displayChatMessages(chatMessages);
  }

  void _displayChatMessages(List<Map<String, dynamic>> chatMessages) {
    // Update the chat messages widget with the retrieved messages
    // Create a ListView or another appropriate widget to display messages
    Widget chatList = ListView.builder(
      itemCount: chatMessages.length,
      itemBuilder: (context, index) {
        final message = chatMessages[index];
        return ChatMessageWidget(
          sender: message['sender'],
          text: message['text'],
          backgroundColor:
              message['sender'] == 'User' ? Colors.blue : Colors.green,
        );
      },
    );

    // Update the UI with the chatList
    // For example, you can replace the placeholder widget
    _updateChatMessagesWidget(chatList);
  }

  void _updateChatMessagesWidget(Widget chatList) {
    // Update the state or rebuild the widget tree with the new chat list
    // You may need to use a StatefulWidget and call setState
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final Color backgroundColor;

  const ChatMessageWidget({
    Key? key,
    required this.sender,
    required this.text,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      tileColor: backgroundColor,
      // Customize the appearance as needed
    );
  }
}

class TableBasicsExample extends StatefulWidget {
  final void Function(DateTime selectedDate,
      List<Map<String, dynamic>> selectedChatMessages) onDateSelected;

  TableBasicsExample({required this.onDateSelected});

  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  List<Map<String, dynamic>> _chatMessages = [];
  List<Map<String, dynamic>> get chatMessages => _chatMessages;

  set chatMessages(List<Map<String, dynamic>> messages) {
    _chatMessages = messages;
  }

  List<Map<String, dynamic>> getChatMessages() {
    return chatMessages;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime.now();
              _selectedDay = DateTime.now();
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent, // Set the outer button color to black
            elevation: 0, // Set the elevation to 0 for no shadow
            side: BorderSide(color: Colors.black),
          ),
          child: Text(
            'Today',
            style:
                TextStyle(color: Colors.black), // Set the text color to black
          ),
        ),
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2023, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) async {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // Retrieve chat messages for the selected date
              final formattedDate = selectedDay.toUtc().toIso8601String();
              final chatMessages = await DatabaseHelper.instance
                  .getChatMessagesForDate(formattedDate);

              // Call the callback to handle the selected date and pass the messages
              widget.onDateSelected(selectedDay, chatMessages);

              // Update the chat messages in the state
              _updateChatMessages(chatMessages);
            }
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

  void _updateChatMessages(List<Map<String, dynamic>> messages) {
    setState(() {
      chatMessages = messages;
    });
  }
}

bool isSameDay(DateTime? dayA, DateTime dayB) {
  return dayA?.year == dayB.year &&
      dayA?.month == dayB.month &&
      dayA?.day == dayB.day;
}
