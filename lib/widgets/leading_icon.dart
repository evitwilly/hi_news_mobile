
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeadingIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_sharp),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

}