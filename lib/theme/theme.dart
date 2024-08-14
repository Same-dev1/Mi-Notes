import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.grey.shade200,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    shape: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      color: Colors.black54,
      fontSize: 15,
      letterSpacing: 0.2,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.black45,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black38,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Colors.grey.shade200,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade200,
    elevation: 0,
    shape: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  brightness: Brightness.light,
  primaryColor: Colors.grey.shade200,
  colorScheme: ColorScheme.light(
      surface: Colors.black,
      primary: Colors.white,
      secondary: Colors.grey.shade200),
);

//DarkMode

ThemeData darkMode = ThemeData(
  appBarTheme: const AppBarTheme(color: Colors.black),
  cardTheme: CardTheme(
    color: Colors.white10,
    elevation: 0,
    shape: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      color: Colors.white38,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    headlineSmall: TextStyle(
      color: Colors.white38,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: Colors.white30,
      fontWeight: FontWeight.normal,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(
        Colors.white10,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    elevation: 0,
    shape: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      surface: Colors.white,
      primary: Colors.grey.shade500,
      secondary: Colors.grey.shade300),
);
