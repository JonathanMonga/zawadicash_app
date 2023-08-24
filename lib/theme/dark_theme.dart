import 'package:flutter/material.dart';
import 'package:zawadicash_app/util/color_resources.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF22d8e7),
  brightness: Brightness.dark,
  secondaryHeaderColor: const Color(0xFF9cec88),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF72e599)),
    titleSmall: TextStyle(color: Color(0xFF25282D)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: ColorResources.themeDarkBackgroundColor),
);
