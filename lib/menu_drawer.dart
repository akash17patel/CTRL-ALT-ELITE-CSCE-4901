import 'package:flutter/material.dart';
import 'package:mindlift_flutter/goals_screen.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:mindlift_flutter/logins_screen.dart';
=======
>>>>>>> parent of cfe805b (update screens)
=======
>>>>>>> parent of cfe805b (update screens)
=======
>>>>>>> parent of cfe805b (update screens)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginsScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text('Chat'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
=======
>>>>>>> parent of cfe805b (update screens)
=======
>>>>>>> parent of cfe805b (update screens)
=======
>>>>>>> parent of cfe805b (update screens)
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
