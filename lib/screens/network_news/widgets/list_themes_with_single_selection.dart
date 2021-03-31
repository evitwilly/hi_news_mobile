
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/domain/my_theme.dart';

class ListThemesWithSingleSelection extends StatelessWidget {

  final List<NewsTheme> themes;
  final NewsTheme selectedTheme;
  final Function onTap;

  ListThemesWithSingleSelection(this.themes, this.selectedTheme, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: themes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 170,
            alignment: Alignment.center,
            child: ListTile(
              selected:  themes[index].name == selectedTheme.name,
              title: Text(
                themes[index].name,
                textAlign: TextAlign.center,
              ),
              onTap: () => onTap(themes[index]),
            ),
          );
        },
      ),
    );
  }
}