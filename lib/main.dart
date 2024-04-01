import 'package:flutter/material.dart';
import 'conversation_history_screen.dart';
import 'goals_screen.dart';
import 'emotion_history.dart';
import 'emergency_contact.dart';
import 'notificationspage.dart';
import 'services/local_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/database.dart';
import 'services/AIClassifier.dart';
import 'chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  MindliftDatabase.instance.database; // Initialize the DB
  await AIClassifier.instance.initModel(); // Init AI model singleton
  runApp(MyApp());
}

Future<void> requestPermissions() async {
  await Permission.microphone.request();
  await Permission.sms.request();
  await Permission.notification.request();
  await Permission.phone.request();
  await Permission.location.request();
}

// Uncomment if using notifications
Future<void> initializeNotifications() async {
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // List of pages to display in the BottomNavigationBar
  final List<Widget> _pages = [
    HomePage(),
    SettingsPage(),
  ];

  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MINDLIFT',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/ML.png',
                height: 70, // Adjust the height as needed
              ),
              SizedBox(width: 10), // Add some space between logo and title
              Text(
                'MINDLIFT',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'OliveRemaine',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 94, 28, 151),
          toolbarHeight: 100,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/purplebg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            PageView(
              controller: _pageController,
              children: _pages,
              onPageChanged: (index) {
                // Set the selected index when the page changes
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 0
                      ? const Color.fromARGB(255, 119, 0, 255)
                      : Colors.grey),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  color: _selectedIndex == 1
                      ? const Color.fromARGB(255, 119, 0, 255)
                      : Colors.grey),
              label: 'Settings',
            ),
          ],
          selectedFontSize: 20, // Adjust the selected font size
          unselectedFontSize: 20, // Adjust the unselected font size
          selectedIconTheme:
              IconThemeData(size: 40), // Adjust the selected icon size
          backgroundColor: Color.fromARGB(
              255, 255, 255, 255), // Background color of bottom bar
          elevation: 5, // Shadow elevation of bottom bar
          type: BottomNavigationBarType.fixed, // Make all items always visible
          selectedItemColor:
              Color.fromARGB(255, 119, 0, 255), // Color of selected item
          unselectedItemColor: Colors.grey, // Color of unselected item
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    // Set the selected index when a navigation item is tapped
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}

// Example home page widget
class HomePage extends StatelessWidget {
  // List of names for each button
  final List<String> buttonNames = [
    'Button 0 Name',
    'Button 1 Name',
    'Button 2 Name',
    'Button 3 Name',
    'Button 4 Name',
    'Button 5 Name',
  ];

  @override
  Widget build(BuildContext context) {
    // Set the text for the "My Goals" button
    buttonNames[0] = 'Chat';
    buttonNames[1] = 'Conversation History';
    buttonNames[2] = 'My Goals';
    buttonNames[3] = 'Emotion History';
    buttonNames[4] = 'Emergency Contact';
    buttonNames[5] = 'Notifications Test';

    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2, // 2 buttons per row
          mainAxisSpacing: 16, // Spacing between rows
          crossAxisSpacing: 16, // Spacing between columns
          childAspectRatio: 1, // Adjust the aspect ratio for button height
          children: List.generate(6, (index) {
            return ElevatedButton(
              onPressed: () {
                // Navigate to a new screen when button is pressed
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationHistoryScreen(),
                      ),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Goals(),
                      ),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmotionHistory(),
                      ),
                    );
                    break;
                  case 4:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmergencyContactsPage(),
                      ),
                    );
                    break;
                  case 5:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 20),
                ),
              ),
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    buttonNames[index], // Centered button text
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// Example settings page widget
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
