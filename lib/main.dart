import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindLift Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(128, 32, 217, 1.0),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(128, 32, 217, 1.0),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'MindLift Demo'),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Tab Content', // Replace this with your actual home tab content
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        key: _scaffoldKey, // Attaching the GlobalKey to the Scaffold
        appBar: AppBar(
          title: Center(
            child: Text(
              'MindLift',
              style: TextStyle(
                fontFamily: 'Merriweather-Bold',
                fontSize: 25.0,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Open the endDrawer (SettingsDrawer)
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: SettingsDrawer(), // Add the SettingsDrawer to the endDrawer
        body: TabBarView(
          children: [
            HomeTab(), // Home Tab content (if any)
            SettingsTab(), // Settings tab content
          ],
        ),
      ),
    );
  }
}

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'Merriweather-LightItalic',
                  fontSize: 35,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              // Implement the action for Option 1, e.g., navigate to a new page
            },
          ),
          ListTile(
            title: Text('Password Reset'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return PasswordResetPage();
                  },
                ),
              );
            },
          ),
          // Add more ListTile items for additional options
        ],
      ),
    );
  }
}

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Open New Tab') {
                DefaultTabController.of(context)
                    ?.animateTo(1); // Change to the index of your new tab
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Open New Tab',
                  child: Text('Open New Tab'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  String _email = '';
  String _message = ''; // Variable to store the message

  void _resetPassword() {
    if (_email.contains('@')) {
      setState(() {
        _message = 'Sent'; // Email is valid, set the message to 'Sent'
      });
    } else {
      setState(() {
        _message =
            'Email Invalid'; // Email is invalid, set the message to 'Email Invalid'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _resetPassword();
              },
              child: Text('Reset Password'),
            ),
            SizedBox(height: 20),
            Text(
              _message, // Display message based on email validation
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
