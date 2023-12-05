import 'package:flutter/material.dart';
import 'database_helper.dart';

class HomeTab extends StatefulWidget {
  final bool isUserLoggedIn;

  HomeTab({required this.isUserLoggedIn});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure that super.build is called
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'), // Set your desired title here
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: _messages[index].isUser
                        ? _buildUserMessage(_messages[index].text)
                        : _buildAiMessage(_messages[index].text),
                  );
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 178, 202, 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('$text (User)', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAiMessage(String text) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text('$text (AI)', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textEditingController.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    if (text.isNotEmpty) {
      // Add user message to UI
      _addMessage(text, true);

      // Store user message in the database
      await DatabaseHelper.instance.storeChatMessage(
          text, true, DateTime.now().toUtc().toIso8601String());

      // Simulate AI response (replace this with actual AI logic)
      String aiResponse = _getAiResponse(text);

      // Add AI message to UI
      _addMessage(aiResponse, false);

      // Store AI message in the database
      await DatabaseHelper.instance.storeChatMessage(
          aiResponse, false, DateTime.now().toUtc().toIso8601String());

      _textEditingController.clear(); // Clear the input field
    }
  }

  void _addMessage(String text, bool isUser) async {
    final timestamp = DateTime.now().toUtc().toIso8601String();

    final result = await DatabaseHelper.instance.storeChatMessage(
      text,
      isUser,
      timestamp,
    );

    if (result != -1) {
      print('Message stored in the database');
    } else {
      print('Error storing message in the database');
    }

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        sender: isUser ? 'User' : 'AI',
        timestamp: timestamp,
      ));
    });
  }

  String _getAiResponse(String userMessage) {
    // Replace this with your AI logic to generate responses based on user input
    // For simplicity, this example just echoes the user's message.
    return 'Good and you?';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String sender;
  final String timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.sender,
    required this.timestamp,
  });
}
