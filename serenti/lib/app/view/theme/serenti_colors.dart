import 'package:flutter/material.dart';

class SerentiColors {
  static const Color azulCielo = Color(0xFFE1F5FE);
  static const Color verdeMenta = Color(0xFFF1F8E9);
  static const Color lavanda = Color(0xFFF3E5F5);
  static const Color crema = Color(0xFFFFF9C4);

  // Gradient definitions for time of day
  static const List<Color> morningGradient = [
    Color(0xFFFFF9C4), // Crema
    Color(0xFFE1F5FE), // Azul Cielo
  ];

  static const List<Color> afternoonGradient = [
    Color(0xFFE1F5FE), // Azul Cielo
    Color(0xFFF1F8E9), // Verde Menta
  ];

  static const List<Color> eveningGradient = [
    Color(0xFFF1F8E9), // Verde Menta
    Color(0xFFF3E5F5), // Lavanda
  ];

  static const Color nightGradientStart = Color(0xFF1A237E); // Indigo 900
  static const Color nightGradientEnd = Color(0xFF000000);   // Black

  static const Color ambarCalma = Color(0xFFFFB74D); // Amber for accent in night mode

  // Alert palette for high risk
  static const List<Color> alertGradient = [
    Color(0xFFFFCC80), // Orange 200 (Ambar suave)
    Color(0xFFCE93D8), // Purple 200 (Lavanda profundo)
  ];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    colorScheme: ColorScheme.fromSeed(
      seedColor: ambarCalma,
      brightness: Brightness.dark,
      primary: ambarCalma,
      surface: const Color(0xFF121212),
    ),
  );
}
