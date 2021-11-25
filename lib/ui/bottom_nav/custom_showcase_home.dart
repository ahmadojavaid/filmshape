import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomShowCaseHome extends StatelessWidget {
  final VoidCallback callback;

  CustomShowCaseHome({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: new BorderRadius.circular(6.0),
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(6.0), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: new EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Text("Projects, talent and more! ",
                          style: new TextStyle(
                              fontFamily: AssetStrings.lotoSemiboldStyle,
                              color: AppColors.kHomeBlack,
                              fontSize: 16))),
                  Container(
                      margin: new EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0),
                      child: CommomHeading(
                          heading:
                              "Create and find projects from the menu, you can also search for talent and edit your settings from here")),
                  InkWell(
                    onTap: () {
                      //all tutorial shown set it to non now
                      MemoryManagement.setToolTipState(
                          state: TUTORIALSTATE.NONE.index);
                      callback(); //tutorial seen
                    },
                    child: Container(
                        margin: new EdgeInsets.only(
                            top: 15.0, left: 30.0, right: 20.0),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Ok,got it",
                              style: new TextStyle(
                                  fontFamily: AssetStrings.lotoSemiboldStyle,
                                  color: AppColors.kPrimaryBlue,
                                  fontSize: 15.5),
                            ),
                            new SizedBox(
                              width: 10.0,
                            ),
                          ],
                        )),
                  ),
                  new SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommomHeading extends StatelessWidget {
  String heading;

  CommomHeading({@required this.heading});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text(
      heading,
      style: new TextStyle(
          fontFamily: AssetStrings.lotoRegularStyle,
          color: AppColors.introBodyColor,
          fontSize: 14.5),
    );
  }
}
