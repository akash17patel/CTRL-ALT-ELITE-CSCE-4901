import 'package:flutter/material.dart';
import 'database_helper.dart' as dbHelper;
import 'user.dart' as myUser;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late dbHelper.DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = dbHelper.DatabaseHelper.instance;
  }

  Future<void> _handleSignUp() async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        print("Error: Passwords do not match");
        return;
      }

      myUser.User user = myUser.User(
        username: _usernameController.text,
        passwordHash: _databaseHelper.hashPassword(_passwordController.text),
      );

      await _databaseHelper.signUp(user);

      print("Signed up successfully");
    } catch (e) {
      print("Error during signup: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _handleSignUp(),
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
