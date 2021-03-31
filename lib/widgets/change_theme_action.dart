import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/data/preferences.dart';
import 'package:hi_news/resources/themes.dart';

class ChangeThemeAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (context) {
        return IconButton(
          onPressed: () {
            bool isDark = ThemeProvider.of(context).brightness == Brightness.light;
            ThemeSwitcher.of(context).changeTheme(theme: isDark ? themeDark : themeLight);
            Preferences.switchDark(isDark);
          },
          icon: Icon(Icons.brightness_3, size: 25),
        );
      },
    );
  }
}
