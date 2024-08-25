import 'package:flutter/material.dart';

TextTheme lightTextTheme = const TextTheme(
  bodyLarge: TextStyle(color: Colors.blue, fontSize: 12),
  bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
  bodySmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  displayLarge: TextStyle(color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
  headlineSmall: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(color: Colors.blue, fontSize: 14),
  titleSmall: TextStyle(color: Colors.blue, fontSize: 12),
);

TextTheme darkTextTheme = const TextTheme(
  bodyLarge: TextStyle(color: Colors.greenAccent, fontSize: 12),
  bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
  bodySmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  displayLarge: TextStyle(color: Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(color: Colors.greenAccent, fontSize: 28, fontWeight: FontWeight.bold),
  displaySmall: TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold),
  headlineSmall: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(color: Colors.greenAccent, fontSize: 14),
  titleSmall: TextStyle(color: Colors.greenAccent, fontSize: 12),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: lightTextTheme,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.blue,
    contentTextStyle: lightTextTheme.bodyMedium,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.lightBlueAccent,
      textStyle: lightTextTheme.bodyMedium,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      textStyle: lightTextTheme.bodyMedium,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, 
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.blue),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3ECF8E),
  scaffoldBackgroundColor: const Color(0xFF1B1B1F),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1B1B1F),
    selectedItemColor: Color(0xFF3ECF8E),
    unselectedItemColor: Colors.white60,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1B1B1F),
    foregroundColor: Colors.white,
  ),
  textTheme: darkTextTheme,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF3ECF8E),
    contentTextStyle: darkTextTheme.bodyMedium,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF3ECF8E),
      textStyle: darkTextTheme.bodyMedium,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: const Color(0xFF3ECF8E),
      textStyle: darkTextTheme.bodyMedium,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3ECF8E),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black12,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF3ECF8E)),
    ),
  ),
);
