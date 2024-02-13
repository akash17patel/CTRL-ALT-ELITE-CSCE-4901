import 'package:flutter/material.dart';
import 'package:mindlift_flutter/chat_screen.dart';
import 'package:mindlift_flutter/conversation_history_screen.dart';
import 'package:mindlift_flutter/emotion_history.dart';
import 'package:mindlift_flutter/goals_screen.dart';
import 'package:mindlift_flutter/login_screen.dart';
import 'package:mindlift_flutter/settings.dart';
import 'package:mindlift_flutter/audio_AI.dart';
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
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
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
            title: Text('Conversation History'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ConversationHistoryScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text('Emotion History'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EmotionHistory();
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
          ListTile(
            title: Text('Audio'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AudioClassificationScreen(title: '',);
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
