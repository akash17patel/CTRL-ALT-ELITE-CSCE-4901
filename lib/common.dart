import 'package:flutter/material.dart';

// Common constants
const primaryColor = Color.fromRGBO(128, 32, 217, 1.0);

class AppConstants {
  // Text Sizes
  static const double textSizeSmall = 12.0;
  static const double textSizeMedium = 16.0;
  static const double textSizeLarge = 20.0;

  // Colors
  static const Color mainColor = Color(0xFF6200EE); // Purple
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color textColor = Color(0xFF000000); // Black
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal
}

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
        icon: Icon(Icons.menu),
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
