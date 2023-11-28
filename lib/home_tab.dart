import 'package:flutter/material.dart';
import 'AI.dart';

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
                  return FutureBuilder<String>(
                    future: _messages[index].text,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListTile(
                          title: _messages[index].isUser
                              ? _buildUserMessage(snapshot.data ?? '')
                              : _buildAiMessage(snapshot.data ?? ''),
                        );
                      } else {
                        // Show a loading indicator or placeholder while waiting
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
              )
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
      _addMessage(Future.value(text), true); // Add user message

      // Await for AI response and then add it to the messages
      String aiResponse = await _getAiResponse(text);
      _addMessage(Future.value(aiResponse), false); // Add AI response

      _textEditingController.clear(); // Clear the input field
    }
  }


  void _addMessage(Future<String> text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
  }

  Future<String> _getAiResponse(String userMessage) async {
    // Replace this with your AI logic to generate responses based on user input
    // For simplicity, this example just echoes the user's message.
    String response = await AI().GetAIResponse(userMessage);
    return response;
  }
}

class ChatMessage {
  final Future<String> text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
