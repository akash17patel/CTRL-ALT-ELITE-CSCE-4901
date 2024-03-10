import 'package:flutter/material.dart';
import 'package:mindlift_flutter/chat_screen.dart';
import 'package:mindlift_flutter/conversation_history_screen.dart';
import 'package:mindlift_flutter/emotion_history.dart';
import 'package:mindlift_flutter/goals_screen.dart';
import 'package:mindlift_flutter/login_screen.dart';
import 'package:mindlift_flutter/settings.dart';
import 'package:mindlift_flutter/audio_AI.dart';
import 'package:mindlift_flutter/notificationspage.dart';
import 'package:mindlift_flutter/emergency_contact.dart';
import 'common.dart';
import 'password_reset_page.dart';
import 'my_profile_page.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          buildDrawerHeader('Menu'),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Chat'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ChatScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('My Goals'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const Goals();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('My Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const MyProfilePage();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Conversation History'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ConversationHistoryScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Emotion History'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const EmotionHistory();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Password Reset'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const PasswordResetPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Notification Test'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return NotificationsPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Emergency Contact'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const EmergencyContactsPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Audio'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AudioClassificationScreen(
                      title: '',
                    );
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
