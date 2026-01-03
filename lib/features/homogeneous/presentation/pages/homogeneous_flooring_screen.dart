import 'package:flutter/material.dart';

class HomogeneousFlooringScreen extends StatelessWidget {
  const HomogeneousFlooringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Homogeneous\nFlooring Page',
          textAlign: TextAlign.center, 
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
