import 'package:flutter/material.dart';

Color primaryTextColor = Colors.black; // Global black text color

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6C4AB6), 
    onPrimary: Colors.black, // Text/Icon color on primary backgrounds
    onSecondary: Colors.black, // Text/Icon color on secondary backgrounds
    onBackground: Colors.black, // Text/Icon color on general backgrounds
    onSurface: Colors.black, // Text/Icon color on surface backgrounds
    onTertiary: Color.fromARGB(255, 255, 255, 255), 
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black, // Text color for TextButton
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, // Text color for ElevatedButton
      backgroundColor: const Color.fromARGB(255, 236, 232, 239), // Optional background color
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black, // Text color for OutlinedButton
      side: const BorderSide(color: Colors.black), // Optional border color
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);
