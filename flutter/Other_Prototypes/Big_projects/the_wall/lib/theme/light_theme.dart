import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20)
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.grey[300]!,
    primary: Colors.grey[200]!,
    secondary: Colors.grey[100]!,
    inversePrimary: Colors.black
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black)
  ),
);