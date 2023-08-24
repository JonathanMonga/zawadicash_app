import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/color_resources.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Rubik',
  primaryColor: const Color(0xFF47DBF0),
  secondaryHeaderColor: const Color(0xFF6DE7A6),
  highlightColor: const Color(0xFF47DBF0),
  primaryColorDark: Colors.black,
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF47DBF0)),
    titleSmall: TextStyle(color: Color(0xFF25282D)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: ColorResources.themeLightBackgroundColor),
  colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.white, background: Colors.white),
);
