import 'package:flutter/material.dart';

class ListAuthors extends StatelessWidget {

  final List<String> authorNames;
  final List<String> selectedAuthorNames;
  final Function onTap;

  ListAuthors(this.authorNames, this.selectedAuthorNames, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      margin: EdgeInsets.only(top: 20, left: 7),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: authorNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 170,
            alignment: Alignment.center,
            child: ListTile(
              selected: isSelected(index),
              title: Text(
                authorNames[index],
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
    return (selectedAuthorNames.length == 0 && index == 0) ||
        (selectedAuthorNames.length > 0 && selectedAuthorNames.contains(authorNames[index]));
  }

}