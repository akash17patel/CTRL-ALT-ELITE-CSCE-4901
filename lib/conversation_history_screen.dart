// conversation_history_screen.dart
import 'package:flutter/material.dart';
//import 'common.dart';

class ConversationHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation History')),
      body: Center(
          child: Text('This screen will contain an organized, '
              'and sortable list of conversations. Conversations will have tags'
              ' and dates.')),
    );
  }
}
