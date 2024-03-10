// login_screen.dart
import 'package:flutter/material.dart';
import 'package:mindlift_flutter/home_screen.dart';
import 'package:mindlift_flutter/my_profile_page.dart';
import 'database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rememberMeController = TextEditingController();
  final _dbHelper = DatabaseHelper.instance;

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }

  void _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });

    if (_rememberMe) {
      // If "Remember Me" is checked, load saved username
      String? savedUsername = prefs.getString('savedUsername');
      _usernameController.text = savedUsername ?? '';
        }
  }

  // To use the db helper to store information
  void _createAccount() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Username and password cannot be empty');
      return;
    }
    // Ideally, add hashing later. This is just for example
    await _dbHelper.storeCredentials(username, password);
    _showMessage('Account Successfully Created!');
  }

  // Check that information
  void _login() async {
    final username = _usernameController.text;
    final enteredPassword = _passwordController.text;

    if (username.isEmpty || enteredPassword.isEmpty) {
      _showMessage('Username and password cannot be empty');
      return;
    }

    if (_rememberMe) {
      // If "Remember Me" is checked, save username to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', true);
      prefs.setString('savedUsername', username);
      MyProfilePage.username = username;
    } else {
      // If "Remember Me" is not checked, clear saved username
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', false);
      prefs.remove('savedUsername');
    }

    final credentials = await _dbHelper.retrieveCredentials(username);
    if (credentials != null) {
      final storedHashedPassword = credentials['password'];

      // Hash the entered password for comparison
      final enteredHashedPassword = _dbHelper.hashPassword(enteredPassword);

      if (storedHashedPassword == enteredHashedPassword) {
        _showMessage('Login Success');

        // Set the username in MyProfilePage
        MyProfilePage.username = username;

        //Navigate to home screen:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(title: 'Login')),
        );
      } else {
        _showMessage('Invalid Password!');
      }
    } else {
      _showMessage('Invalid Username!');
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
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text('Remember Me'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: _createAccount,
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ])));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
