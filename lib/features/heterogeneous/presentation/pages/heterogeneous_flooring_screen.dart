import 'package:flutter/material.dart';

class HeterogeneousFlooringScreen extends StatelessWidget {
  const HeterogeneousFlooringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Heterogeneous\nFlooring Page',
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
