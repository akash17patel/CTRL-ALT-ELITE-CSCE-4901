import 'package:flutter/material.dart';
import 'services/local_notification_service.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key})
      : service = LocalNotificationService() {
    service.initialize();
  }

  final LocalNotificationService service;

  @override
  Widget build(BuildContext context) {
    listenToNotification(context); // Pass the context here

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
              child: const Text('Show Local Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showScheduledNotification(
                    id: 0,
                    title: 'Notification Title',
                    body: 'Test is working',
                    seconds: 3);
              },
              child: const Text('Show Scheduled Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showNotificationWithPayload(
                    id: 0,
                    title: 'Notification Title',
                    body: 'Test is working',
                    payload: 'payload navigation');
              },
              child: const Text('Show Payload Notification'),
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

      /*Navigator.push(
        context,
        MaterialPageRoute(builder: ((context) => main(payload: payload))),
      );*/
    }
  }
}
