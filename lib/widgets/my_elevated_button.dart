import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  final EdgeInsets padding;
  MyElevatedButton(this.text, this.onPressed, {this.padding = const EdgeInsets.only(left: 10, right: 10)});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = ThemeProvider.of(context).brightness == Brightness.light;
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: isLightTheme
              ? Colors.green[500]
              : Colors.grey,
        padding: padding,
      ),
    );
  }

}