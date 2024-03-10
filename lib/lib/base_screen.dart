import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final String title;

  const BaseScreen({super.key, required this.body, required this.title});

  // Temporary content in base screen
  // We need to think about (if any) content that all screens will have.
  // Possibly a logo in corner, or home button etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ],
      ),
      body: body,
    );
  }
}
