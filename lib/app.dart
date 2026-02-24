import 'dart:async';
import 'package:batch35_floorease/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:batch35_floorease/features/splash/presentation/pages/splash_screen.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription<int>? _proximitySubscription;
  bool _isNear = false;

  @override
  void initState() {
    super.initState();
    _listenToProximitySensor();
  }

  void _listenToProximitySensor() {
    _proximitySubscription = ProximitySensor.events.listen((event) {
      setState(() {
        _isNear = event > 0;
      });
    });
  }

  @override
  void dispose() {
    _proximitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: getApplicationTheme(),
      darkTheme: getDarkApplicationTheme(),
      themeMode: ThemeMode.light,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (_isNear) Positioned.fill(child: Container(color: Colors.black)),
          ],
        );
      },
    );
  }
}
