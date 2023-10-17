import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindLift Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(128, 32, 217, 1.0),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(128, 32, 217, 1.0),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'MindLift Demo'),
    );
  }
}
