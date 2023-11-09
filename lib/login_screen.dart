// login_screen.dart
import 'package:flutter/material.dart';
import 'common.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('This screen will allow the user to log in')),
    );
  }
}
