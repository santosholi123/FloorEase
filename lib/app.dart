import 'package:flutter/material.dart';
import 'package:batch35_floorease/screens/login_screen.dart';
import 'package:batch35_floorease/screens/splash_screen.dart';
import 'package:batch35_floorease/screens/create_account_screen.dart';
import 'package:batch35_floorease/screens/home_screen.dart';
import 'package:batch35_floorease/Screens/onboarding_three_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingThreeScreen(),
      theme: ThemeData(
        primaryColor: const Color(0xFF0A2463),
      ),
    );
  }
}
