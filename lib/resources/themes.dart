import 'package:flutter/material.dart';

final themeDark = ThemeData.dark().copyWith(
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
      )
  ),
);

final themeLight = ThemeData.light().copyWith(
  primaryColor: Colors.green[500],
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: Colors.green[500],
    ),
  ),
  accentColor: Colors.green[500],
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.black,
    indicator: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.green[500], width: 2))
    )
  ),
);
