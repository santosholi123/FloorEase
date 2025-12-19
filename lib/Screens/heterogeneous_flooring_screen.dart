import 'package:flutter/material.dart';

class HeterogeneousFlooringScreen extends StatelessWidget {
  const HeterogeneousFlooringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Heterogeneous Flooring Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
