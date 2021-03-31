
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/resources/strings.dart';

class NewPageErrorIndicator extends StatelessWidget {

  NewPageErrorIndicator(this.retryLastFailedRequest);

  final Function retryLastFailedRequest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Strings.failedLoaded, textAlign: TextAlign.center,),
        OutlinedButton(
            onPressed: () {
              retryLastFailedRequest();
            },
            child: Text(Strings.retry)),
      ],
    );
  }

}