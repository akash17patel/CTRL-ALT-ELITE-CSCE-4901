import 'package:flutter/material.dart';
import 'menu_drawer.dart';
import 'menu_tab.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isUserLoggedIn = false; //Track if user is logged

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Center(
            child: Text(
              'MindLift',
              style: TextStyle(
                fontFamily: 'Merriweather-Bold',
                fontSize: 25.0,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: const SettingsDrawer(),
        body: TabBarView(
          children: [
            HomeTab(isUserLoggedIn: isUserLoggedIn),
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}
