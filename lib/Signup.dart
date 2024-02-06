// most recent code

import 'package:flutter/material.dart';
import 'Login.dart'; // Import your login.dart file

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  _MySignUpPageState createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Create an Account',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  'Username',
                  'Enter username',
                  Icons.person,
                  controller: _usernameController,
                  obscureText: true,
                ),
                buildTextField(
                  'Enter your email',
                  '',
                  Icons.email,
                  controller: _emailController,
                  obscureText: true,
                ),
                buildTextField(
                  'Enter Password',
                  '',
                  Icons.lock,
                  controller: _passwordController,
                  obscureText: true,
                ),
                buildTextField(
                  'Confirm Password',
                  '',
                  Icons.lock,
                  controller: _confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // All fields are filled, you can proceed with sign-up logic here.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    foregroundColor: Color.fromARGB(255, 240, 197, 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, 'login');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyLoginPage()));
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    String hintText,
    IconData icon, {
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else if (labelText == 'Enter your email' && !isEmailValid(value)) {
            return 'Please enter a valid email address.';
          }
          return null;
        },
      ),
    );
  }

  bool isEmailValid(String email) {
    // Regular expression to validate email format
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }
}
