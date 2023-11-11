import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '/database_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late DatabaseHelper _databaseHelper; // Declare the database helper

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance; // Use the named constructor
  }

  Future<User?> _handleGoogleSignIn() async {
    // ... (unchanged code for Google Sign-In)
  }

  Future<void> _handleEmailPasswordSignIn() async {
  try {
    // Removed Firebase authentication code

    // Retrieve stored credentials
    Map<String, dynamic>? storedCredentials = await _databaseHelper.retrieveCredentials(_usernameController.text);

    if (storedCredentials != null &&
        storedCredentials['password'] == _databaseHelper.hashPassword(_passwordController.text)) {
      // Passwords match
      // Navigate to the next screen or perform further actions
      print("Logged in successfully");
    } else {
      // Handle incorrect credentials
      print("Error: Incorrect username or password");
    }
  } catch (e) {
    // Handle local email/password login errors
    print("Error during local email/password login: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                User? user = await _handleGoogleSignIn();
                if (user != null) {
                  // User successfully signed in with Google
                  // Navigate to the next screen or perform further actions
                } else {
                  // Handle sign-in cancellation or failure
                }
              },
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _handleEmailPasswordSignIn(),
              child: Text('Login with Email and Password'),
            ),
          ],
        ),
      ),
    );
  }
}
