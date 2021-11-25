import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';

class PurchaseBottomSheet extends StatelessWidget {

 final VoidCallback callBackButtonClick;
  PurchaseBottomSheet(this.callBackButtonClick);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
            child: SingleChildScrollView(
              child: Container(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: new EdgeInsets.only(
                          left: 30.0, right: 15.0, top: 15.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: new Icon(Icons.keyboard_arrow_down,
                                  size: 29.0)),
                          new SizedBox(
                            width: 4.0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: new Text(
                              "Close",
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                          ),
                          Expanded(
                            child: new SizedBox(
                              width: 55.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      height: 1,
                      margin: new EdgeInsets.only(top: 15.0),
                      color: AppColors.dividerColor,
                    ),
                    Container(
                      margin:
                      new EdgeInsets.only(top: 30, left: 40, right: 40),
                      child: new Text(
                        "Add unlimited roles to a project with a Pro account",
                        style:
                        AppCustomTheme.createProfileSubTitleBottomSheet,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          top: 15.0, left: 40.0, right: 40.0),
                      child: new Text(
                        "Project team members are limited to 10 users, you can upgrade to a pro account to have unlimited members and much more!",
                        style: AppCustomTheme.body15Regular,
                      ),
                    ),
                    Container(
                        margin: new EdgeInsets.only(top: 30.0),
                        child: getSetupButton(callBackButtonClick,
                            "View all the Pro features", MARGIN_LEFT_RIGHT)),
                    new SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            )));
  }
}
