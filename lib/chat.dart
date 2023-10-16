// chat_screen.dart
import 'package:flutter/material.dart';
import 'constants.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Center(child: Text('Welcome to Chat!')),
    );
  }
}
