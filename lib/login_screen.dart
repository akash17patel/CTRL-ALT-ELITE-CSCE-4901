// login_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//import 'common.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<User?> _handleGoogleSignIn() async {
    try {
      // Trigger the Google Sign-In process
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return null;
      }

      // Obtain GoogleSignInAuthentication object
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credentials using GoogleSignInAuthentication
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Ensure the user is verified
      if (userCredential.user != null && userCredential.user!.email != null) {
        // User successfully signed in with Google
        // Navigate to the next screen or perform further actions
        print("Logged into this email address: ${userCredential.user!.email}");
        return userCredential.user;
      } else {
        // User not verified or email not available
        // Handle authentication failure
        print("Error: User not verified or email not available");
        return null;
      }
    } catch (e) {
      // Handle sign-in errors
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> _handleEmailPasswordSignIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      // Handle local email/password login success, navigate to the next screen, etc.
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
