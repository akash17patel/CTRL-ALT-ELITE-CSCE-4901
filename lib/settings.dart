import 'package:flutter/material.dart';
import 'common.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  double _textSize = AppConstants.textSizeMedium;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final themeData = AppConstants.getTheme(_isDarkMode);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add a back button icon
            onPressed: () {
              Navigator.pop(context); // Add navigation to go back
            },
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Text Size'),
              trailing: DropdownButton<double>(
                value: _textSize,
                items: [
                  DropdownMenuItem(
                    child: Text('Small'),
                    value: AppConstants.textSizeSmall,
                  ),
                  DropdownMenuItem(
                    child: Text('Medium'),
                    value: AppConstants.textSizeMedium,
                  ),
                  DropdownMenuItem(
                    child: Text('Large'),
                    value: AppConstants.textSizeLarge,
                  ),
                ],
                onChanged: (double? value) {
                  if (value != null) {
                    setState(() {
                      _textSize = value;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Language'),
              trailing: DropdownButton<String>(
                value: _language,
                items: [
                  DropdownMenuItem(
                    child: Text('English'),
                    value: 'English',
                  ),
                  DropdownMenuItem(
                    child: Text('Japanese'),
                    value: 'Japanese',
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _language = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
