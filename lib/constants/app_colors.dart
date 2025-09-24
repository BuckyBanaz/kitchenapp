import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE53935); // Red
  static const Color primaryDark = Color(0xFFD32F2F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFF8F2F2); // Inputs bg
  static const Color successGreen = Color(0xFF4CAF50); // Order confirmed tick
// Define MaterialColor from base primary
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFE53935,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      250: Color(0xFFB56C6C),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFE53935), // primary
      600: Color(0xFFD32F2F),
      700: Color(0xFFC62828),
      800: Color(0xFFB71C1C),
      900: Color(0xFFB71C1C),
    },
  );
}
