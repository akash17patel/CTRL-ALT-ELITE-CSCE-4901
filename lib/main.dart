//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home_screen.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper;

  await DatabaseHelper.instance.database; // This will initialize the database
  //await DatabaseHelper.instance.getAllTablesInDataBase();

  runApp(MyApp()); // Use Splash Screen as the initial screen display
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
