
import 'package:flutter/cupertino.dart';
import 'package:hi_news/resources/constants.dart';
import 'package:hi_news/resources/strings.dart';

class NotSavedNewsMessage extends StatelessWidget {

  NotSavedNewsMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Image.asset(Constants.NOT_FOUND),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                  Strings.emptySavedNews,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

}