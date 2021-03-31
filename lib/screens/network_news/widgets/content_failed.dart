
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/resources/constants.dart';
import 'package:hi_news/resources/strings.dart';

class ContentFailed extends StatelessWidget {

  final Function refresh;

  ContentFailed(this.refresh);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Image.asset(Constants.MISSING_INTERNET_IMAGE),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                  Strings.contentFailedLoaded,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
            ),
            Container(
              child: OutlinedButton(
                child: Text(Strings.retry),
                onPressed: () {
                  refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}