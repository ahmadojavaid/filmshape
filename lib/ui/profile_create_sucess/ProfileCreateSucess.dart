import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/bottom_nav/bottom_nav.dart';

class ProfileCreateSuccess extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ProfileCreateSuccess> {
  Widget addProjectView(String text, IconData image,int type) {
    return InkWell(
      onTap: (){
       moveToDashBoard(type);// 1- create project, 2-join project , 3-add a credits
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(color: AppColors.kPrimaryBlue, width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Icon(
              image,
              color: AppColors.kPrimaryBlue,
              size: 17.0,
            ),
            new SizedBox(
              width: 12.0,
            ),

            new Text(
              text,
              style: AppCustomTheme.profileCreatedButtonStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar("Profile created"),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: new Column(
                  children: <Widget>[
                    new SizedBox(height: 40),
                    Container(
                      alignment: Alignment.center,
                      child: new SvgPicture.asset(
                        AssetStrings.ic_tick,
                        height: 40.0,
                        width: 40.0,
                        color: AppColors.kPrimaryBlue,
                      ),
                    ),
                    new SizedBox(
                      height: 15,
                    ),
                    new Text(
                      "Your profile is complete!",
                      style: AppCustomTheme.createProfileSubTitle,
                    ),
                    Container(
                        margin:
                            new EdgeInsets.only(top: 15.0, left: 45.0, right: 45.0),
                        child: new Text(
                          "Now don't forget you can add credits to\nyour profile and begin finding people for a\nmore tailored experience.",
                          style: AppCustomTheme.body15Regular,
                          textAlign: TextAlign.center,
                        )),
                    new SizedBox(
                      height: 40,
                    ),
                    addProjectView("Create a project", Icons.add_box,1),
                    new SizedBox(
                      height: 20,
                    ),
                    addProjectView("Join a project", Icons.people,2),
                    new Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          new EdgeInsets.only(top: 40.0, left: 40.0, right: 30.0),
                      child: new Text(
                        "Add a film credit from a complete project",
                        style: new TextStyle(fontFamily: AssetStrings.lotoLightStyle),
                      ),
                    ),
                    new SizedBox(
                      height: 17,
                    ),
                    addProjectView("Add a credit", Icons.add_box,3),

                  ],
                ),
              ),
              getContinueProfileSetupButton(callback, "Thanks, got it!"),
              new SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback callback()
  {
    moveToDashBoard(0);
  }

  void moveToDashBoard(int type)
  {
    Navigator.pushAndRemoveUntil(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new BottomNavigation(type: type,);
      }),
          (route) => false,
    );
  }
}
