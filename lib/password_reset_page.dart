import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  String _email = '';
  String _message = '';

  void _resetPassword() {
    if (_email.contains('@')) {
      setState(() {
        _message = 'Sent';
      });
    } else {
      setState(() {
        _message = 'Email Invalid';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _resetPassword();
              },
              child: Text('Reset Password'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
