
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hi_news/resources/strings.dart';

class SelectedAuthors extends StatelessWidget {

  final List<String> selectedAuthorNames;

  SelectedAuthors(this.selectedAuthorNames);

  @override
  Widget build(BuildContext context) {
    final text = selectedAuthorNames.length < 1
        ? Strings.currentAuthors + Strings.everything
        : Strings.currentAuthors + selectedAuthorNames.join(", ");
    print(selectedAuthorNames);
    print(text);
    return Container(
      margin: EdgeInsets.only(left: 7, top: 10),
      child: Text(
          text,
          style: TextStyle(fontSize: 14, height: 2)
      ),
    );
  }

}