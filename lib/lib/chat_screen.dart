// chat_screen.dart
import 'package:flutter/material.dart';
//import 'common.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(
          child: Text(
              'This screen is where the user will directly interact with the'
              ' chatbot AI. It will contain an input and output section.')),
    );
  }
}
