
import 'package:flutter/cupertino.dart';
import 'package:hi_news/resources/strings.dart';

class SelectedSingleTheme extends StatelessWidget {

  final String selectedTheme;

  SelectedSingleTheme(this.selectedTheme);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 7, top: 10),
      child: Text(
          Strings.currentTheme + selectedTheme,
          style: TextStyle(fontSize: 14, height: 2)
      ),
    );
  }
}