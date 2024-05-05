import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/database.dart';
import 'services/AIClassifier.dart';

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
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadTodaysConversations();
  }

  void _loadTodaysConversations() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<Map<String, dynamic>> todaysMessages =
        await MindliftDatabase.instance.getChatMessagesForDate(today);

    setState(() {
      // Create a new mutable list from the fetched data
      messages = List<Map<String, dynamic>>.from(todaysMessages);
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom(delayed: true));
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
    _scrollToBottom(delayed: true); // Add this line

    _controller.clear();
    _simulateAIMessage(text);
  }

  void _simulateAIMessage(String userMessage) async {
    String aiResponse = await getAIResponse(userMessage);

    final aiMessage = {
      'sender': 'AI',
      'text': aiResponse,
      'timestamp': DateTime.now(),
    };
    MindliftDatabase.instance
        .insertChatMessage('AI', aiResponse, DateTime.now());
    setState(() {
      messages.add(aiMessage);
    });
    _scrollToBottom(delayed: true); // Add this line
  }

  Future<String> getAIResponse(String userMessage) async {
    // Send the text to the AI
    String response = await AIClassifier.instance.getAIResponse(userMessage);
    print(response);
    return response;
  }

  void _scrollToBottom({bool delayed = false}) {
    final delay = delayed ? Duration(milliseconds: 100) : Duration.zero;
    Future.delayed(delay, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUserMessage = msg['sender'] == 'User';

                /* Code, if it didnt pull up a red screen, would display
                todays date, not the date stored. Logic needs a rework.
                DateTime dateTime = DateTime.parse(msg['timestamp']);
                var formatter = DateFormat('dd/mmm/yyyy HH:mm');
                String formattedDate = formatter.format(dateTime);


                 */


                return ListTile(
                  title: Text(
                    msg['text'],
                    style: TextStyle(
                        color: isUserMessage ? Colors.blue : Colors.green),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['sender'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                       Text(
                        msg['timestamp'].toString().split('T').first,
                    //  msg['timestamp'],
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                      ),
                    ],
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
                    decoration:
                        InputDecoration(hintText: 'Type your message here...'),
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
