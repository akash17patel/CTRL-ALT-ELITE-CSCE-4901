import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatelessWidget {
  final String payload;

  NotificationDetailsPage({required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Center(
        child: Text('Notification Payload: $payload'),
      ),
    );
  }
}
