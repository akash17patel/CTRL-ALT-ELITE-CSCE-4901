// chat_screen.dart
import 'package:flutter/material.dart';
//import 'common.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Center(
          child: Text(
              'This screen is where the user will directly interact with the'
              ' chatbot AI. It will contain an input and output section.')),
    );
  }
}
