// login_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart'; //

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper.instance;

  // To use the db helper to store information
  void _signup() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    // Ideally, add hashing later. This is just for example
    await _dbHelper.storeCredentials(username, password);
    _showMessage('Signup Successful');
  }

  // Check that information
  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final credentials = await _dbHelper.retrieveCredentials(username);
    if (credentials != null && credentials['password'] == password) {
      _showMessage('Login Success');
    } else {
      _showMessage('Invalid username or password');
    }
  }

  // To implement the message
  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override // Flutter stuff to show stuff
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: _signup,
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
