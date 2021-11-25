import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';

class BottomSheetTopHeaderWidget extends StatelessWidget {
  final VoidCallback callback;
  BottomSheetTopHeaderWidget(this.callback);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(
          left: BOTTOMSHEET_MARGIN_LEFT_RIGHT,
          right: BOTTOMSHEET_MARGIN_LEFT_RIGHT,
          top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: bottomSheetCloseButton()),
          InkWell(
              onTap: () {
                callback();
              },
              child: bottomSheetSaveButton()),
        ],
      ),
    );
  }
}