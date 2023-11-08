// login_screen.dart
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'common.dart';

class LoginsScreen extends StatefulWidget {
  @override
  _LoginsScreenState createState() => _LoginsScreenState();
}

class _LoginsScreenState extends State<LoginsScreen> {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  void _handleFacebookLogin() async {
    AccessToken? accessToken;
    final LoginResult result =
        await _facebookAuth.login(permissions: ['email']);
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      // Handle Facebook login success and navigate to the desired screen.
    } else if (result.status == LoginStatus.cancelled) {
      // Handle Facebook login cancellation.
    } else {
      // Handle Facebook login error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _handleFacebookLogin,
              child: Text('Sign in with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
