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
import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';

//enum FontSize { small, medium, large }

/*
extension FontSizeExtension on FontSize {
  int get value {
    switch (this) {
      case FontSize.small:
        return 0;
      case FontSize.medium:
        return 1;
      case FontSize.large:
        return 2;
    }
  }
}*/
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
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
                  ElevatedButton(
                    onPressed: () {
                      navigateToMainContent();
                    },
                    child: Text('Continue without PIN'),
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
 /* FontSize _selectedFontSize = FontSize.medium; // Default font size
  late SharedPreferences _prefs;

  //late FontSize _selectedFontSize;*/

  @override
  void initState() {
    super.initState();
    _loadSettings();
   // _loadFontSize();
  }

  Future<void> _loadSettings() async {
    bool darkMode = await MindliftDatabase.instance.getDarkMode();
    bool pincodeEnabled = await MindliftDatabase.instance.getPincode() != null;
 /*   _prefs = await SharedPreferences.getInstance();
    _selectedFontSize =
    FontSize.values[_prefs.getInt('fontSize') ?? FontSize.medium.index];*/

    setState(() {
      _isDarkMode = darkMode;
      _isPincodeEnabled = pincodeEnabled;
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
/*
  // New methods to save and load font size
  Future<void> _saveFontSize(FontSize fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('font_size', fontSize.value);
  }

  Future<void> _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? fontSizeValue = prefs.getInt('font_size');
    if (fontSizeValue != null) {
      setState(() {
        _selectedFontSize =
            FontSize.values.firstWhere((size) => size.value == fontSizeValue);
      });
    }
  }

  Future<void> _setFontSize(FontSize fontSize) async {
    await _saveFontSize(fontSize); // Save the selected font size
    setState(() {
      _selectedFontSize = fontSize; // Update the selected font size
    });
  }
*/
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

  /* Future<void> _setFontSize(FontSize fontSize) async {
    // Implementation for setting font size
    setState(() {
      _selectedFontSize = fontSize;
    });
  }*/

  @override
  Widget build(BuildContext context) {
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
            Padding(
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
           /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Font Size',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  DropdownButton<FontSize>(
                    value: _selectedFontSize,
                    onChanged: (FontSize? newValue) {
                      if (newValue != null) {
                        _setFontSize(newValue); // Apply the selected font size
                      }
                    },
                    items: FontSize.values.map((FontSize fontSize) {
                      return DropdownMenuItem<FontSize>(
                        value: fontSize,
                        child: Text(
                          fontSize
                              .toString()
                              .split('.')
                              .last,
                          style: TextStyle(
                            fontSize: _getFontSize(
                                fontSize), // Use the selected font size here
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),*/
            Padding(
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
            // Font Size Setting
            /*ListTile(
              title: Text('Font Size'),
              trailing: DropdownButton<FontSize>(
                value: _selectedFontSize,
                onChanged: (FontSize? newSize) {
                  if (newSize != null) {
                    _setFontSize(newSize);
                  }
                },
                items: FontSize.values.map((fontSize) {
                  return DropdownMenuItem<FontSize>(
                    value: fontSize,
                    child: Text(fontSizeToString(fontSize)),
                  );
                }).toList(),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
/*
  // Helper function to get font size for dropdown items
  double _getFontSize(FontSize fontSize) {
    switch (fontSize) {
      case FontSize.small:
        return 16.0; // Small font size
      case FontSize.medium:
        return 20.0; // Medium font size
      case FontSize.large:
        return 24.0; // Large font size
      default:
        return 20.0; // Default to medium font size
    }
  }*/
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
            obscureText: true, // Display bullet points
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
