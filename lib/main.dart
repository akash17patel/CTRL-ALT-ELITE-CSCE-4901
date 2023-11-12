import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mindlift_flutter/checkIn_page.dart';
import 'package:mindlift_flutter/screens/signup.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  // }
  // // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // // this step, it will use the sqlite version available on the system.
  // databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignUpPage(),
    );
  }
}
