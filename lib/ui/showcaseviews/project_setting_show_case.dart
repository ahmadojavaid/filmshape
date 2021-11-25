import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProjectSettingShowCase extends StatelessWidget {
  final VoidCallback callback;

  ProjectSettingShowCase({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(bottom: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(right: 43.0, top: 0.0),
            child: new SvgPicture.asset(
              AssetStrings.trianlge,
              width: 40.0,
              height: 18.0,
              color: Colors.white,
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(6.0),
                color: Colors.white),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin:
                        new EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: CommomHeading(
                        heading: "Project managers and settings")),
                Container(
                    margin:
                        new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                    child: CommomHeading(
                        heading:
                            "To add more project managers, upgrade to Filmshape Pro, permission include;")),
                Container(
                    margin:
                        new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                    child: CommomHeading(heading: "- Edit project details.")),
                Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child:
                        CommomHeading(heading: "- Invite users to a project.")),
                Container(
                  margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                  child: CommomHeading(heading: "- Accept/Decline appicants."),
                ),
                Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: CommomHeading(
                        heading: "- Add, edit and delete roles.")),
                Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: CommomHeading(
                        heading: "- Remove people from a project.")),
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
                            "Ok, thanks",
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
