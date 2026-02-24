import 'dart:async';
import 'package:flutter/foundation.dart';

/// Light Sensor Service for automatic theme switching
/// Note: Light sensor is not available on all devices through sensors_plus.
/// This implementation provides a graceful fallback approach.
class LightSensorService {
  Timer? _lightCheckTimer;
  double _lastLux = 100.0; // Default to bright light
  static const double _alpha = 0.15; // Low-pass filter smoothing factor

  /// Starts monitoring ambient light
  /// [onLux] callback is called with smoothed lux value
  ///
  /// Note: Since light sensors are not universally available via sensors_plus,
  /// this implementation uses time-based heuristics as a fallback.
  /// On devices with actual light sensors, platform channels can be added.
  void start({required Function(double lux) onLux}) {
    try {
      // Start periodic light simulation based on time of day
      // In production, this would connect to platform-specific light sensor APIs
      _lightCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        final now = DateTime.now();
        final hour = now.hour;

        // Simulate lux values based on time of day
        // Morning/Afternoon: bright (100-500 lux)
        // Evening/Night: dark (1-10 lux)
        double simulatedLux;

        if (hour >= 7 && hour < 19) {
          // Daytime: bright
          simulatedLux = 150.0 + (hour - 7) * 10;
        } else if (hour >= 19 && hour < 21) {
          // Evening: dim
          simulatedLux = 30.0 - (hour - 19) * 10;
        } else {
          // Night: dark
          simulatedLux = 5.0;
        }

        // Apply low-pass filter for smoothing
        _lastLux = _lastLux + _alpha * (simulatedLux - _lastLux);

        // Call the callback with smoothed lux value
        onLux(_lastLux);
      });
    } catch (e) {
      debugPrint('Light sensor service error: $e');
    }
  }

  /// Stops listening to light sensor events
  void stop() {
    _lightCheckTimer?.cancel();
    _lightCheckTimer = null;
  }

  /// Clean up resources
  void dispose() {
    stop();
  }
}
