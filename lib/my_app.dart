import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:hi_news/screens/home/home_screen.dart';
import 'package:hi_news/screens/splash/splash_screen.dart';
import 'data/preferences.dart';
import 'resources/themes.dart';
import 'screens/error/error_screen.dart';

class MyApp extends StatelessWidget {

  final bool isDark;

  MyApp({this.isDark});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialize(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildApp(ErrorScreen());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildApp(HomeScreen());
        }
        return _buildApp(SplashScreen());
      },
    );
  }

  Widget _buildApp(Widget homePage) {
    final initTheme = isDark ? themeDark : themeLight;
    return ThemeProvider(
        initTheme: initTheme,
        child: Builder(builder: (context) {
          return MaterialApp(
            title: "Новости",
            theme: ThemeProvider.of(context),
            home: homePage,
          );
        })
    );
  }

  Future<void> _initialize() async {
    await Firebase.initializeApp();
  }
}


