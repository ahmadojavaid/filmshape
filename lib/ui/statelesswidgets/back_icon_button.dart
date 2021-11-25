import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';

class BackButtonButton extends StatelessWidget {
  final String title;

  BackButtonButton(this.title);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: new EdgeInsets.only(left: 35.0),
               child: Row(
              children: <Widget>[
                new Icon(
                  Icons.keyboard_backspace,
                  size: 25.0,
                  color: Colors.black,
                ),
                new SizedBox(
                  width: 8.0,
                ),
                new Text(
                  title,
                  style: new TextStyle(
                      fontFamily: AssetStrings.lotoSemiboldStyle,
                      fontSize: 16.0),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
