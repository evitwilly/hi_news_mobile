
import 'package:flutter/cupertino.dart';
import 'package:hi_news/resources/strings.dart';

class SelectedSomeThemes extends StatelessWidget {

  final List<String> selectedThemeNames;

  SelectedSomeThemes(this.selectedThemeNames);

  @override
  Widget build(BuildContext context) {
    final text = selectedThemeNames.length < 1
        ? Strings.selectedThemes + Strings.everything
        : Strings.selectedThemes + selectedThemeNames.join(", ");
    return Container(
      margin: EdgeInsets.only(left: 7, top: 10),
      child: Text(
          text,
          style: TextStyle(fontSize: 14, height: 2)
      ),
    );
  }

}