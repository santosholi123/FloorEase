import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class AppConfig {
  // Your development laptop's IP address (update this when your IP changes)
  static const String devLaptopIp = '192.168.1.10';

  // Port for your backend server
  static const int port = 4000;

  // Android emulator uses special IP to access host machine
  static const String androidEmulatorIp = '10.0.2.2';

  // iOS simulator uses localhost
  static const String iosSimulatorIp = 'localhost';

  static String? _cachedBaseUrl;

  /// Get the appropriate base URL based on platform and device type
  ///
  /// Returns:
  /// - Android Emulator: http://10.0.2.2:4000
  /// - iOS Simulator: http://localhost:4000
  /// - Real Device: http://192.168.1.10:4000
  static Future<String> get baseUrl async {
    // Return cached value if available
    if (_cachedBaseUrl != null) {
      return _cachedBaseUrl!;
    }

    String hostIp;

    if (Platform.isAndroid) {
      // Check if running on physical device or emulator
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.isPhysicalDevice) {
        // Real Android device - use laptop IP
        hostIp = devLaptopIp;
      } else {
        // Android emulator - use special emulator IP
        hostIp = androidEmulatorIp;
      }
    } else if (Platform.isIOS) {
      // Check if running on physical device or simulator
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;

      if (iosInfo.isPhysicalDevice) {
        // Real iOS device - use laptop IP
        hostIp = devLaptopIp;
      } else {
        // iOS simulator - use localhost
        hostIp = iosSimulatorIp;
      }
    } else {
      // Fallback for other platforms (desktop, web)
      hostIp = devLaptopIp;
    }

    _cachedBaseUrl = 'http://$hostIp:$port';
    return _cachedBaseUrl!;
  }

  /// Clear cached base URL (useful for testing or manual refresh)
  static void clearCache() {
    _cachedBaseUrl = null;
  }
}
