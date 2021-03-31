
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/resources/constants.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/widgets/diamond_information_widget.dart';

class FirstPageErrorIndicator extends StatelessWidget {

  FirstPageErrorIndicator(this.refresh);

  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 50),
            child: Image.asset(Constants.MISSING_INTERNET_IMAGE),
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: Text(Strings.failedRefresh,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                )),
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
    );
  }

}