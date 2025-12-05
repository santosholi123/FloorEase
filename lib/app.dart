import 'package:flutter/material.dart';
import 'package:batch35_floorease/screens/splash_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: const Color(0xFF0A2463),
      ),
    );
  }
}
