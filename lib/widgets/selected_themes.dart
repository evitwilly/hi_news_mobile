
import 'package:flutter/material.dart';
import 'package:hi_news/domain/my_theme.dart';
import 'package:hi_news/resources/strings.dart';

// class SelectedThemes extends StatelessWidget {
//
//   final List<String> selectedThemeNames;
//
//   SelectedThemes(this.selectedThemeNames);
//
//   @override
//   Widget build(BuildContext context) {
//     final text = selectedThemeNames.length < 1
//         ? Strings.currentThemes + Strings.everything
//         : Strings.currentThemes + selectedThemes.map((theme) => theme.name).join(", ");
//     return Container(
//       margin: EdgeInsets.only(left: 7, top: 10),
//       child: Text(
//           text,
//           style: TextStyle(fontSize: 14, height: 2)
//       ),
//     );
//   }
//
// }