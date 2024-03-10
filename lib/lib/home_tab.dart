import 'package:flutter/material.dart';
import 'AI.dart';
import 'database_helper.dart';

class HomeTab extends StatefulWidget {
  final bool isUserLoggedIn;

  const HomeTab({super.key, required this.isUserLoggedIn});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AI ai = AI();

  @override
  void initState() {
    super.initState();
    ai.initModel().then((_) {
      print("AI Model initialized");
    }).catchError((error) {
      print("Error initializing AI model: $error");
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure that super.build is called
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'), // Set your desired title here
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
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
                        return const CircularProgressIndicator();
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
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 178, 202, 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('$text (User)', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAiMessage(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text('$text (AI)', style: const TextStyle(color: Colors.white)),
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
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textEditingController.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    if (text.isNotEmpty) {
      DateTime now = DateTime.now();
      String timestamp = now.toIso8601String(); // Use current time as timestamp

      _addMessage(Future.value(text), true); // Add user message
      await _saveMessageToDb(text, true, timestamp); // Save user message to DB

      // Await for AI response and then add it to the messages
      String aiResponse = await _getAiResponse(text);
      _addMessage(Future.value(aiResponse), false); // Add AI response
      await _saveMessageToDb(aiResponse, false, timestamp); // Save AI response to DB

      _textEditingController.clear(); // Clear the input field
    }
  }



  void _addMessage(Future<String> text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
  }

  Future<String> _getAiResponse(String userMessage) async {

    // Future
    String response = await ai.GetAIResponse(userMessage);
    return response;
  }

  Future<void> _saveMessageToDb(String message, bool isUser, String timestamp) async {
    try {
      await DatabaseHelper.instance.storeChatMessage(message, isUser, timestamp);
    } catch (e) {
      print('Error saving message to database: $e');
    }
  }

}

class ChatMessage {
  final Future<String> text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
