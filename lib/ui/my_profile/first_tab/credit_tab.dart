import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/ui/join_project/join_project.dart';
import 'package:Filmshape/ui/my_profile/first_tab/video_view_create_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreditTabProfile extends StatefulWidget {
  final String userId;
  final MyProfileResponse response;
  final ValueChanged<Widget> fullScreenWidget;

  CreditTabProfile(this.userId, this.fullScreenWidget, {this.response, Key key})
      :super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<CreditTabProfile>
    with AutomaticKeepAliveClientMixin<CreditTabProfile>
{

  List<Projectss> projectsList = new List();

  @override
  void initState() {
    super.initState();
    if (widget.response != null) {
      if (widget.response.credits != null &&
          widget.response.credits.length > 0) {
        projectsList.addAll(widget.response.credits);
      }
    }
  }

  void moveToJoinProject() async
  {
    await Navigator.push(
      context,
      new CupertinoPageRoute(
          builder: (BuildContext context) {
            return new JoinProject(widget.fullScreenWidget, type: 1,);
          }),
    );
  }
  Widget videoLinkView(String text, IconData image) {
    return InkWell(
      onTap: () {
       moveToJoinProject();
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(color: AppColors.kPrimaryBlue, width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
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
              style: new TextStyle(
                  color: AppColors.kPrimaryBlue,
                  fontSize: 15.5,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new ListView(
        children: <Widget>[
          new SizedBox(
            height: 30.0,
          ),
          (isCurrentUser(widget.userId))
              ? new SizedBox(
            height: 10.0,
          )
              : Container(),

          (isCurrentUser(widget.userId))
              ? videoLinkView("Add a credit", Icons.add_box)
              : Container(),


          (isCurrentUser(widget.userId))
              ? new SizedBox(
            height: 35.0,
          )
              : Container(),


          //    _buildContestList()
        ]
          ..addAll(new List.generate(projectsList.length, (index) {

            return VideoCreateTabProfileView(
                projectsList[index].project, widget.fullScreenWidget,saveAward: false,);
          })),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
