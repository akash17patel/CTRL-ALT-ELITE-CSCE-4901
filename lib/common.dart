import 'package:flutter/material.dart';

// Common constants
const primaryColor = Color.fromRGBO(128, 32, 217, 1.0);

// Common AppBar widget
AppBar buildAppBar(String title, GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    title: Center(
      child: Text(
        title,
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
        icon: Icon(Icons.settings),
        onPressed: () {
          scaffoldKey.currentState?.openEndDrawer();
        },
      ),
    ],
  );
}

// Common Drawer Header widget
DrawerHeader buildDrawerHeader(String title) {
  return DrawerHeader(
    decoration: BoxDecoration(
      color: primaryColor, // Use the primaryColor constant here
    ),
    child: Container(
      height: 150,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Merriweather-LightItalic',
            fontSize: 35,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    ),
  );
}
