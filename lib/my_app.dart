import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:hi_news/screens/home/home_screen.dart';
import 'resources/themes.dart';


class MyApp extends StatelessWidget {

  final bool isDark;

  MyApp({this.isDark});

  @override
  Widget build(BuildContext context) {
    final initTheme = isDark ? themeDark : themeLight;
    return ThemeProvider(
        initTheme: initTheme,
        child: Builder(builder: (context) {
          return MaterialApp(
            title: "Новости",
            theme: ThemeProvider.of(context),
            home: HomeScreen(),
          );
        })
    );

  }


}


