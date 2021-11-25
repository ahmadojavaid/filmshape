import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonInviteApply extends StatelessWidget {
  final String title;
  ButtonInviteApply({this.title});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      alignment: Alignment.center,
      width: 120.0,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 7, bottom: 7),
      decoration: new BoxDecoration(
          color: AppColors.kPrimaryBlue,
          borderRadius: new BorderRadius.circular(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            title,
            style: new TextStyle(
                fontFamily: AssetStrings.lotoSemiboldStyle,
                color: Colors.white,
                fontSize: 13.0),
          ),
          new SizedBox(width: 10.0),
          new SvgPicture.asset(
            AssetStrings.send,
            color: Colors.white,
            width: 15.0,
            height: 15.0,
          )
        ],
      ),
    );
  }
}
