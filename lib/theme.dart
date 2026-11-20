import 'package:flutter/material.dart';

class UsmColors {
  static const azul = Color(0xFF1F5FA8);
  static const azulOscuro = Color(0xFF0F3D7A);
  static const azulClaro = Color(0xFF6FA3DC);
  static const dorado = Color(0xFFF5AE1B);
  static const ambar = Color(0xFFC98700);
  static const crema = Color(0xFFFFE9B3);
  static const rojo = Color(0xFFD62828);
  static const verde = Color(0xFF1E8A4C);
}

final usmTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: UsmColors.azul,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD6E6F8),
    onPrimaryContainer: UsmColors.azulOscuro,
    secondary: UsmColors.dorado,
    onSecondary: UsmColors.azulOscuro,
    secondaryContainer: UsmColors.crema,
    tertiary: UsmColors.verde,
    error: UsmColors.rojo,
    surface: Colors.white,
    onSurface: Color(0xFF14213D),
  ),
  scaffoldBackgroundColor: const Color(0xFFF6F8FC),
  appBarTheme: const AppBarTheme(
    backgroundColor: UsmColors.azul,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: UsmColors.dorado,
    foregroundColor: UsmColors.azulOscuro,
  ),
);