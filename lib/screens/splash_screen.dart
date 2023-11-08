import 'package:flutter/material.dart';
import 'package:mindlift_flutter/utils/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Image(
      image: AssetImage(Config.app_icon),
      height: 80,
      width: 80,
    ))));
  }
}
