import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final bool isUserLoggedIn;

  HomeTab({required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Tab Content',
      ),
    );
  }
}
