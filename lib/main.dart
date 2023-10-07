import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindLift Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(210, 28, 182, 213),
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
          'Home Tab Content'), // Replace this with your actual home tab content
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('MindLift',
                style: TextStyle(
                  fontFamily: 'Merriweather-Bold',
                  fontSize: 25.0,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                )),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
            indicatorColor: Color.fromARGB(255, 0, 0, 0),
            unselectedLabelColor: Color.fromARGB(255, 87, 87, 87),
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(), //Home Tab content (if any)
            SettingsTab(), //Settings tab content
          ],
        ),
      ),
    );
  }
}

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String _email = '';
  String _message = ''; //Variable to store the message

  void _resetPassword() {
    if (_email.contains('@')) {
      setState(() {
        _message = 'Sent'; //Email is valid, set the message to 'Sent'
      });
    } else {
      setState(() {
        _message =
            'Email Invalid'; //Email invalid, set message to 'Email Invalid'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
