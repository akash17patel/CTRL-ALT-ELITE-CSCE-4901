// import 'package:flutter/material.dart';
// import 'package:mindlift_flutter/chat_screen.dart';
// import 'package:mindlift_flutter/conversation_history_screen.dart';
// import 'package:mindlift_flutter/emotion_history.dart';
// import 'package:mindlift_flutter/goals_screen.dart';
// import 'package:mindlift_flutter/login_screen.dart';
// import 'package:mindlift_flutter/screens/sign_up_page.dart';
// import 'package:mindlift_flutter/settings.dart';
// import 'common.dart';
// import 'password_reset_page.dart';
// import 'my_profile_page.dart';

// class SettingsDrawer extends StatelessWidget {
//   const SettingsDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           buildDrawerHeader('Menu'),
//           ListTile(
//             title: const Text('Login'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return LoginScreen();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Chat'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return ChatScreen();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('My Goals'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return GoalsScreen();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('My Profile'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return MyProfilePage();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Conversation History'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return ConversationHistoryScreen();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Emotion History'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return EmotionHistory();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Password Reset'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return PasswordResetPage();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return SettingsScreen();
//                   },
//                 ),
//               );
//             },
//           ),
//            ListTile(
//             title: const Text('Sign Up'),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return SignUpPage();
//                   },
//                 ),
//               );
//             },
//           ),
//           // Add more ListTile items for additional options
//         ],
//       ),
//     );
//   }
// }
