import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Service that manages gyroscope sensor data and provides smooth tilt values
/// for parallax effects. Uses low-pass filter to smooth out sensor noise.
class GyroscopeTiltService {
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Smoothed tilt values
  double _smoothedTiltX = 0.0;
  double _smoothedTiltY = 0.0;

  // Smoothing factor (higher = more smoothing, but slower response)
  static const double _smoothingFactor = 0.9;
  static const double _sensitivityFactor = 0.1;

  // Clamp limits to prevent extreme tilts
  static const double _maxTilt = 0.6;
  static const double _minTilt = -0.6;

  // ValueNotifier to expose tilt values reactively
  final ValueNotifier<Offset> tiltNotifier = ValueNotifier<Offset>(Offset.zero);

  bool _isActive = false;
  bool get isActive => _isActive;

  /// Start listening to gyroscope events
  void start() {
    if (_isActive) return;

    _isActive = true;

    try {
      _gyroscopeSubscription = gyroscopeEventStream().listen(
        _onGyroscopeEvent,
        onError: (error) {
          debugPrint('Gyroscope error: $error');
          // Silently disable on error (sensor not available)
          _isActive = false;
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('Failed to start gyroscope: $e');
      _isActive = false;
    }
  }

  /// Handle incoming gyroscope events
  void _onGyroscopeEvent(GyroscopeEvent event) {
    // Gyroscope returns rotation rate (rad/s)
    // We use y rotation for X-axis tilt, x rotation for Y-axis tilt

    // Apply low-pass filter for smoothing
    _smoothedTiltX =
        _smoothedTiltX * _smoothingFactor + event.y * _sensitivityFactor;
    _smoothedTiltY =
        _smoothedTiltY * _smoothingFactor + event.x * _sensitivityFactor;

    // Clamp values to prevent extreme movements
    _smoothedTiltX = _smoothedTiltX.clamp(_minTilt, _maxTilt);
    _smoothedTiltY = _smoothedTiltY.clamp(_minTilt, _maxTilt);

    // Update the notifier
    tiltNotifier.value = Offset(_smoothedTiltX, _smoothedTiltY);
  }

  /// Stop listening to gyroscope events
  void stop() {
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
    _isActive = false;

    // Reset tilt values
    _smoothedTiltX = 0.0;
    _smoothedTiltY = 0.0;
    tiltNotifier.value = Offset.zero;
  }

  /// Dispose of resources
  void dispose() {
    stop();
    tiltNotifier.dispose();
  }
}
