import 'package:flutter/material.dart';

class SportsFlooringScreen extends StatelessWidget {
  const SportsFlooringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Sports Flooring Page',
          style: TextStyle(
            fontSize: 24,
            //fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
