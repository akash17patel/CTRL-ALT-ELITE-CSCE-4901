// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Open New Tab') {
                DefaultTabController.of(context)
                    .animateTo(1); // Change to the index of your new tab
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Open New Tab',
                  child: Text('Open New Tab'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
