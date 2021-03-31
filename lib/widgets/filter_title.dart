
import 'package:flutter/cupertino.dart';

class FilterTitle extends StatelessWidget {

  final String title;

  FilterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 7, top: 30),
      child: Text(
        title,
        style: TextStyle(fontSize: 19,),
      ),
    );
  }

}