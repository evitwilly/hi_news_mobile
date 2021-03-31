
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/resources/strings.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName)
      ),
      body: Center(
        child: Text(Strings.initializeError),
      ),
    );
  }
}