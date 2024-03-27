import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadTodaysConversations();
  }

  void _loadTodaysConversations() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<Map<String, dynamic>> todaysMessages = await MindliftDatabase.instance.getChatMessagesForDate(today);

    setState(() {
      // Create a new mutable list from the fetched data
      messages = List<Map<String, dynamic>>.from(todaysMessages);
    });
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    final message = {
      'sender': 'User',
      'text': text,
      'timestamp': DateTime.now(),
    };

    MindliftDatabase.instance.insertChatMessage('User', text, DateTime.now());

    setState(() {
      messages.add(message);
    });

    _controller.clear();
    _simulateAIMessage(text);
  }

  void _simulateAIMessage(String userMessage) {
    // Placeholder for AI logic
    String aiResponse = getAIResponse(userMessage);

    final aiMessage = {
      'sender': 'AI',
      'text': aiResponse,
      'timestamp': DateTime.now(),
    };
    MindliftDatabase.instance.insertChatMessage('User', aiResponse, DateTime.now());
    setState(() {
      messages.add(aiMessage);
    });
  }

  String getAIResponse(String userMessage) {
    // AI logic stub
    // For demonstration, simply reverses the user's message
    return 'AI response to: $userMessage';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUserMessage = msg['sender'] == 'User';
                return ListTile(
                  title: Text(
                    msg['text'],
                    style: TextStyle(color: isUserMessage ? Colors.blue : Colors.green),
                  ),
                  subtitle: Text(
                    msg['sender'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type your message here...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
