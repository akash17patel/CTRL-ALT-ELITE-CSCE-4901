import 'package:flutter/material.dart';
import 'services/local_notification_service.dart';
import 'services/NotificationDetailsPage.dart'; // Import the NotificationDetailsPage

class NotificationsPage extends StatelessWidget {
  NotificationsPage({Key? key})
      : service = LocalNotificationService(),
        super(key: key) {
    service.initialize();
  }

  final LocalNotificationService service;

  @override
  Widget build(BuildContext context) {
    listenToNotification(context); // Pass the context here

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await service.showNotification(
                    id: 0,
                    title: 'Notification Title',
                    body: 'Test is working');
              },
              child: Text('Show Local Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showScheduledNotification(
                    id: 0,
                    title: 'Notification Title',
                    body: 'Test is working',
                    seconds: 3);
              },
              child: Text('Show Scheduled Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showNotificationWithPayload(
                    id: 0,
                    title: 'Notification Title',
                    body: 'Test is working',
                    payload: 'payload navigation');
              },
              child: Text('Show Payload Notification'),
            ),
          ],
        ),
      ),
    );
  }

  void listenToNotification(BuildContext context) =>
      service.onNotificationClick.stream.listen((String? payload) {
        onNotificationListener(context, payload);
      });

  void onNotificationListener(BuildContext context, String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => NotificationDetailsPage(payload: payload))),
      );
    }
  }
}
