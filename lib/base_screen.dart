import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final String title;

  BaseScreen({required this.body, required this.title});

  // Temporary content in base screen
  // We need to think about (if any) content that all screens will have.
  // Possibly a logo in corner, or home button etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ],
      ),
      body: body,
    );
  }
}
