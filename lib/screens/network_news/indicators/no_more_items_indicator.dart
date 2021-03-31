
import 'package:flutter/cupertino.dart';
import 'package:hi_news/resources/strings.dart';

class NoMoreItemsIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Center(
        child: Text(
          Strings.newsIsNotExists,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}