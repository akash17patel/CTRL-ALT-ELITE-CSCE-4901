import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatefulWidget {
  final String payload;
  final Duration delay;

  NotificationDetailsPage(
      {required this.payload, this.delay = const Duration(seconds: 10)});

  @override
  _NotificationDetailsPageState createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  @override
  void initState() {
    super.initState();
    print('Init state called'); // Add this debug print
    print('Delay: ${widget.delay}'); // Debug message
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        // Navigate back after the delay
        print('Navigating back...'); // Debug message
        //Navigator.pop(context);
        try {
          Navigator.pop(context);
        } catch (e) {
          print('Exception occurred: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Center(
        child: Text('Notification Payload: ${widget.payload}'),
      ),
    );
  }
}
