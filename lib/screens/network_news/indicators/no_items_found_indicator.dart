
import 'package:flutter/cupertino.dart';
import 'package:hi_news/resources/constants.dart';
import 'package:hi_news/resources/strings.dart';

class NoItemsFoundIndicator extends StatelessWidget {

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
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Text(Strings.filterNetworkFailed,
                  textAlign: TextAlign.justify,
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