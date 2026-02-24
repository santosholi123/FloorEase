import 'package:flutter/material.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _autoModeEnabled = true; // Default AUTO enabled
  bool _isDarkMode = false; // Track current mode for hysteresis

  // Hysteresis thresholds
  static const double _darkThreshold = 12.0;
  static const double _lightThreshold = 20.0;

  ThemeMode get themeMode => _themeMode;
  bool get autoModeEnabled => _autoModeEnabled;

  /// Enable or disable automatic theme mode based on light sensor
  void setAutoMode(bool enabled) {
    if (_autoModeEnabled != enabled) {
      _autoModeEnabled = enabled;
      notifyListeners();
    }
  }

  /// Manually set theme mode (overrides auto mode)
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _autoModeEnabled = false; // Disable auto when manually set
      notifyListeners();
    }
  }

  /// Apply lux value from light sensor (internal use)
  /// Uses hysteresis to prevent flickering
  void applyLux(double lux) {
    if (!_autoModeEnabled) return;

    ThemeMode newMode;

    // Apply hysteresis logic
    if (lux <= _darkThreshold) {
      // Dark environment
      newMode = ThemeMode.dark;
      _isDarkMode = true;
    } else if (lux >= _lightThreshold) {
      // Bright environment
      newMode = ThemeMode.light;
      _isDarkMode = false;
    } else {
      // Between thresholds - keep previous mode (hysteresis)
      newMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }

    // Only notify if mode actually changed
    if (_themeMode != newMode) {
      _themeMode = newMode;
      notifyListeners();
    }
  }
}
