import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // Primary color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),

    // Use Material 3
    useMaterial3: true,

    // Font
    fontFamily: 'OpenSansRegular',

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'OpenSansSemiBoldItalic',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white, size: 24),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // button color
        foregroundColor: Colors.white, // text color
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(
          fontFamily: 'OpenSansSemiBold',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    ),

    // FloatingActionButton Theme (optional)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
  );
}

ThemeData getDarkApplicationTheme() {
  return ThemeData(
    // Primary color scheme for dark mode
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),

    // Use Material 3
    useMaterial3: true,

    // Font
    fontFamily: 'OpenSansRegular',

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple.shade700,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'OpenSansSemiBoldItalic',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white, size: 24),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade700, // button color
        foregroundColor: Colors.white, // text color
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(
          fontFamily: 'OpenSansSemiBold',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    ),

    // FloatingActionButton Theme (optional)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple.shade700,
      foregroundColor: Colors.white,
    ),
  );
}
