import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindlift_flutter/database_repository.dart';
import 'package:mindlift_flutter/model/user_model.dart';
import 'package:mindlift_flutter/screens/users_list.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  void initDb() async {
    await DatabaseRepository.instance.database;
  }

  @override
  void initState() {
    initDb();
    super.initState();
  }

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // final db = FirebaseFirestore.instance;

  // late CollectionReference users;

  // @override
  // void initState() {
  //  users  = db.collection('users');
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // CollectionReference users = db.collection('users');

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up Page')),
      body: Column(children: [
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(hintText: 'First Name'),
        ),
        TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(hintText: 'last Name')),
        TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Email  ')),
        TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'Password Name')),
        ElevatedButton(
            onPressed: () async {
              UserModel user = UserModel(
                firstname: _firstNameController.text.trim(),
                lastname: _lastNameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );
              await DatabaseRepository.instance
                  .insert(user: user)
                  // ignore: avoid_print
                  .then((value) => {
                        // print("User Created " + value.toString())
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDataTableScreen()))
                      });
            },
            child: const Text('Sign Up'))
      ]),
    );
  }
}
