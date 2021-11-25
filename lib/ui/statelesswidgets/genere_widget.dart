import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenereWidget extends StatelessWidget {
  final String genere;

  GenereWidget({@required this.genere});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
      decoration: new BoxDecoration(
          color: AppColors.kPrimaryBlue,
          borderRadius: new BorderRadius.circular(5.0)),
      child: new Text(
        genere,
        style: new TextStyle(
            fontFamily: AssetStrings.lotoSemiboldStyle,
            color: AppColors.white,
            fontSize: 13.0),
      ),
    );
  }
}
