import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        new Icon(Icons.keyboard_arrow_down, size: 29.0),
        new SizedBox(
          width: 4.0,
        ),
        new Text(
          "Close",
          style: new TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ],
    );
  }
}
