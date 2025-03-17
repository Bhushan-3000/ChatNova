import 'package:flutter/material.dart';

import 'Colors.dart';

var darkTheme = ThemeData();
var lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,



  colorScheme: const ColorScheme.light(
      primary: lPrimaryColor,
      onPrimary: lOnBgColor,
      surface: lBgColor,
      onSurface: lBgColor,
      primaryContainer: lContainerColor,
      onPrimaryContainer: lOnContainerColor),
textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: lPrimaryColor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w800,
),
  headlineMedium: TextStyle(
    fontSize: 30,
    color: lPrimaryColor,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w500,
  ),
  headlineSmall: TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
  ),
  labelLarge: TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w400,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    color: Colors.blueGrey,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w400,
  ),
  labelSmall: TextStyle(
    fontSize: 10,
    color: lOnContainerColor,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  ),
  bodyLarge: TextStyle(
    fontSize: 18,
    color: lOnBgColor,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w500,
  ),
  bodyMedium: TextStyle(
    fontSize: 15,
    color: lOnBgColor,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w500,
  ),
),
);
