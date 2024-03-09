import 'package:flutter/material.dart';
import 'common.dart';
import 'password_reset_page.dart';
import 'my_profile_page.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          buildDrawerHeader('Settings'),
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
          // Add more ListTile items for additional options
        ],
      ),
    );
  }
}
