import 'package:Filmshape/Utils/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyWidget extends StatelessWidget {
  String message;
  VoidCallback callback;
  bool isEnabled;

  EmptyWidget(
      {@required this.message,
      @required this.callback,
      @required this.isEnabled});

  @override
  Widget build(BuildContext context) {

    return new Center(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      
        new Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.kAppBlack,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
//        new FlatButton(
//            onPressed: isEnabled ? callback : null,
//            child: new Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                new Icon(
//                  Icons.refresh,
//                  color: AppColors.kAppBlack,
//                ),
//                new Text(
//                  "Refresh",
//                  style: new TextStyle(
//                      fontSize: 18.0, color: AppColors.kAppBlack),
//                ),
//              ],
//            ))
      ],
    ));
  }
}
