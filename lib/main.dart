import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_lift/resources_page.dart';
import 'conversation_history_screen.dart';
import 'goals_screen.dart';
import 'emotion_history.dart';
import 'emergency_contact.dart';
import 'services/local_notification_service.dart';
import 'services/NotificationDetailsPage.dart'; // Import the NotificationDetailsPage
import 'package:permission_handler/permission_handler.dart';
import 'services/database.dart';
import 'services/AIClassifier.dart';
import 'chat_screen.dart';
import 'dart:async';
import 'services/audio_AI.dart';

// Define 'service' as a global variable
final LocalNotificationService service = LocalNotificationService();

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print("Flutter bindings initialized.");

    await requestPermissions();
    print("Permissions requested.");

    await MindliftDatabase.instance.database; // Initialize the DB
    print("Database initialized.");

    await AIClassifier.instance.initModel(); // Init AI model singleton
    print("AI model initialized.");

    await service.initialize();

    bool crisisDetect = await MindliftDatabase.instance.getCrisisDetection();

    if (crisisDetect) print("Crisis Detection Allowed");

    if (await Permission.microphone.isGranted && crisisDetect) { // Check microphone permission explicitly
      print("Microphone permission granted.");
      //startForegroundService();
      // Moving from foreground service for demo functionality.

      await AudioClassification.instance.turnOn();
    } else {
      print("Microphone permission not granted.");
    }

    runApp(MyApp());
    print("App running.");
  } catch (e, s) {
    print("Error during initialization: $e");
    print("Stack trace: $s");
  }
}

Future<void> requestPermissions() async {
  await Permission.microphone.request();
  //await Permission.sms.request();
  await Permission.notification.request();
  await Permission.phone.request();
  await Permission.storage.request();
  //await Permission.location.request();
}

Future<void> initializeNotifications() async {
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MINDLIFT',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _pincode = '';
  bool _isPincodeEnabled = false;
  bool _isNewUser = false;

  @override
  void initState() {
    super.initState();
    checkPincodeStatus();
  }

  Future<void> checkPincodeStatus() async {
    bool isPincodeSet = await MindliftDatabase.instance.getPincode() != null;
    setState(() {
      _isPincodeEnabled = isPincodeSet;
    });
  }

  void navigateToMainContent() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyAppContent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isNewUser) {
      return Scaffold(
        body: Container(
          color: Colors.black, // Black bg color
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to MINDLIFT!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    navigateToMainContent();
                  },
                  child: Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: Colors.black, // Black bg color
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isPincodeEnabled)
                  Text(
                    'Enter PIN Code',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (_isPincodeEnabled) SizedBox(height: 20),
                if (_isPincodeEnabled)
                  PinCodeInput(
                    onChanged: (pin) {
                      _pincode = pin;
                    },
                  ),
                if (_isPincodeEnabled) SizedBox(height: 20),
                if (_isPincodeEnabled)
                  ElevatedButton(
                    onPressed: () async {
                      bool isValid = await MindliftDatabase.instance
                          .verifyPincode(_pincode);
                      if (isValid) {
                        navigateToMainContent();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Incorrect PIN Code. Please try again.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                if (!_isPincodeEnabled)
                  Column(
                    children: [
                      Image.asset(
                        'assets/ML.png',
                        height: 120, // Adjust the height as needed
                      ),
                      ElevatedButton(
                        onPressed: () {
                          navigateToMainContent();
                        },
                        child: Text('CONTINUE TO MINDLIFT'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class MyAppContent extends StatefulWidget {
  @override
  _MyAppContentState createState() => _MyAppContentState();
}

class _MyAppContentState extends State<MyAppContent> {
  final List<Widget> _pages = [
    HomePage(),
    SettingsPage(),
  ];

  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    buttonNames[5] = 'Resources';

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
                        builder: (context) => ResourcesPage(),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(255, 255, 255, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 20),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          60), // Set border radius to 0 for square shape
                      side: BorderSide(
                        color: Colors.white,
                        width: 4,
                      )),
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

// Settings page widget
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false; // Variable to store dark mode state
  bool _isPincodeEnabled = false; // Variable to store pincode enabled state
  bool _isCrisisDetectionEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    listenToNotification(context);
    service.initialize();
  }

  Future<void> _loadSettings() async {
    bool darkMode = await MindliftDatabase.instance.getDarkMode();
    bool pincodeEnabled = await MindliftDatabase.instance.getPincode() != null;
    bool crisisDetection = await MindliftDatabase.instance.getCrisisDetection();

    setState(() {
      _isDarkMode = darkMode;
      _isPincodeEnabled = pincodeEnabled;
      _isCrisisDetectionEnabled = crisisDetection;
    });
  }

  Future<void> _setDarkMode(bool isDarkMode) async {
    await MindliftDatabase.instance.setDarkMode(isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  Future<void> _setPincodeEnabled(bool isEnabled) async {
    if (isEnabled) {
      // Show Pincode Setup Popup
      String? pincode = await _showPincodeSetupPopup();
      if (pincode != null) {
        await MindliftDatabase.instance.setPincode(pincode);
        setState(() {
          _isPincodeEnabled = true;
        });
      }
    } else {
      // Check if PIN code is set before disabling
      bool isPincodeSet = await MindliftDatabase.instance.getPincode() != null;
      if (isPincodeSet) {
        // Ask for current PIN code
        String? currentPincode = await _showCurrentPincodePopup();
        String? savedPincode = await MindliftDatabase.instance.getPincode();

        if (currentPincode == savedPincode) {
          // If the current PIN code matches, then disable PIN code
          await MindliftDatabase.instance.delete('Pincode', 1);
          setState(() {
            _isPincodeEnabled = false;
          });
        } else {
          // If the current PIN code does not match, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect PIN Code. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // If PIN code is not set, simply disable PIN code
        await MindliftDatabase.instance.delete('Pincode', 1);
        setState(() {
          _isPincodeEnabled = false;
        });
      }
    }
  }

  Future<String?> _showCurrentPincodePopup() async {
    String? pincode;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Current PIN Code'),
          content: TextField(
            onChanged: (value) {
              pincode = value;
            },
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              hintText: 'Enter 4-digit Pincode',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(pincode);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    return pincode;
  }

  Future<String?> _showPincodeSetupPopup() async {
    String? pincode;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Pincode'),
          content: TextField(
            onChanged: (value) {
              pincode = value;
            },
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              hintText: 'Enter 4-digit Pincode',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(pincode);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    return pincode;
  }
  
  @override
  Widget build(BuildContext context) {
    listenToNotification(context); // Listen to notifications
    return Padding(
      padding: EdgeInsets.all(15), // 5 pixels padding from all sides
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), // Background color with opacity
          borderRadius: BorderRadius.circular(15), // Rounded corners
          border: Border.all(
            color: Colors.white, // Border color
            width: 5, // Border width
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                'SETTINGS',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      _setDarkMode(value);
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            */Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Set Pincode Lock',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: _isPincodeEnabled,
                    onChanged: (value) {
                      _setPincodeEnabled(value);
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Crisis Detection',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: _isCrisisDetectionEnabled,
                    onChanged: (value) {
                      _setCrisisDetectionEnabled(value);
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Set Notification Reminder',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await service.showNotification(
                        id: 0,
                        title: 'Notification Title',
                        body: 'Test is working',
                      );
                    },
                    child: Text(
                      'Set Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // Modify the listenToNotification function to accept 'context' as a parameter
  void listenToNotification(BuildContext context) {
    service.onNotificationClick.stream.listen((String? payload) {
      onNotificationListener(context, payload);
    });
  }

// Modify the onNotificationListener function to accept 'context' as a parameter
  void onNotificationListener(BuildContext context, String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailsPage(
              payload: payload, delay: Duration(seconds: 10)),
        ),
      );
    }
  }

  void _setCrisisDetectionEnabled(bool value) async {
    if (await Permission.microphone.isGranted) {
      await MindliftDatabase.instance.setCrisisDetection(value);

      // If value is true then turn detection, otherwise off.
      if (value) await AudioClassification.instance.turnOn();
      else await AudioClassification.instance.turnOff();
      setState(() {
        _isCrisisDetectionEnabled = value;
      });
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Microphone Permission Required"),
            content: Text("Crisis detection only works with the microphone enabled. Please enable microphone access in your settings."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class PinCodeInput extends StatefulWidget {
  final Function(String) onChanged;

  const PinCodeInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  _PinCodeInputState createState() => _PinCodeInputState();
}

class _PinCodeInputState extends State<PinCodeInput> {
  final List<FocusNode> _pinNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _pinNodes) {
      node.dispose();
    }
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 60,
          height: 60,
          child: TextField(
            controller: _pinControllers[index],
            focusNode: _pinNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                _pinNodes[index].unfocus();
                FocusScope.of(context).requestFocus(_pinNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                _pinNodes[index].unfocus();
                FocusScope.of(context).requestFocus(_pinNodes[index - 1]);
              }
              if (value.length > 1) {
                _pinControllers[index].text = value.substring(0, 1);
                _pinControllers[index].selection =
                    TextSelection.collapsed(offset: 1);
              }
              widget.onChanged(getPin());
            },
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            maxLength: 1,
            style: TextStyle(
                color: Colors.white, fontSize: 24), // Set text color and size
            onTap: () {
              _pinNodes[index].requestFocus();
            },
          ),
        );
      }),
    );
  }

  String getPin() {
    String pin = '';
    for (var controller in _pinControllers) {
      pin += controller.text;
    }
    return pin;
  }
}
