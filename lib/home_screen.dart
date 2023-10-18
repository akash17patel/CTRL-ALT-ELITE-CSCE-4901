import 'package:flutter/material.dart';
import 'menu_drawer.dart';
import 'menu_tab.dart';
import 'home_tab.dart';
import 'common.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Text(
              'MindLift',
              style: TextStyle(
                fontFamily: 'Merriweather-Bold',
                fontSize: 25.0,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: SettingsDrawer(),
        body: TabBarView(
          children: [
            HomeTab(),
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}
