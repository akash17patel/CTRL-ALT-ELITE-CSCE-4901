import 'package:flutter/material.dart';
import 'common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Add a back button icon
            onPressed: () {
              Navigator.pop(context); // Add navigation to go back
            },
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Dark Mode'),
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
              title: const Text('Text Size'),
              trailing: DropdownButton<double>(
                value: _textSize,
                items: const [
                  DropdownMenuItem(
                    value: AppConstants.textSizeSmall,
                    child: Text('Small'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.textSizeMedium,
                    child: Text('Medium'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.textSizeLarge,
                    child: Text('Large'),
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
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(
                    value: 'English',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'Japanese',
                    child: Text('Japanese'),
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
