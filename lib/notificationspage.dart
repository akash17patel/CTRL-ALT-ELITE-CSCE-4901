import 'package:flutter/material.dart';
import 'services/local_notification_service.dart';
import 'services/NotificationDetailsPage.dart'; // Import the NotificationDetailsPage

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final LocalNotificationService service = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    listenToNotification(); // Listen to notifications

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
                  body: 'Test is working',
                );
              },
              child: Text('Show Local Notification'),
            ),
          ],
        ),
      ),
    );
  }

  void listenToNotification() {
    service.onNotificationClick.stream.listen((String? payload) {
      onNotificationListener(payload);
    });
  }

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailsPage(payload: payload),
        ),
      );
    }
  }
}
