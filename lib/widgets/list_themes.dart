
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/domain/my_theme.dart';
import 'package:hi_news/resources/strings.dart';

class ListThemes extends StatelessWidget {

  final List<String> themeNames;
  final List<String> selectedThemeNames;
  final Function onTap;

  ListThemes(this.themeNames, this.selectedThemeNames, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      margin: EdgeInsets.only(top: 20, left: 7),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: themeNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 170,
            alignment: Alignment.center,
            child: ListTile(
              selected: isSelected(index),
              title: Text(
                themeNames[index],
                textAlign: TextAlign.center,
              ),
              onTap: () => onTap(isSelected(index), index),
            ),
          );
        },
      ),
    );
  }

  bool isSelected(int index) {
    return (selectedThemeNames.length == 0 && index == 0) ||
        (selectedThemeNames.length > 0 && selectedThemeNames.contains(themeNames[index]));
  }

}