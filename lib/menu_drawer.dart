import 'package:flutter/material.dart';
import 'package:mindlift_flutter/goals_screen.dart';
import 'package:mindlift_flutter/settings.dart';
import 'common.dart';
import 'password_reset_page.dart';
import 'my_profile_page.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          buildDrawerHeader('Menu'),
          ListTile(
            title: Text('My Goals'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return GoalsScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MyProfilePage();
                  },
                ),
              );
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
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsScreen();
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
