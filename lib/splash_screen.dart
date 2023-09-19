import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          "Splash Screen",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
