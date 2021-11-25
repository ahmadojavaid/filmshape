import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/full_view_team/full_view_team_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamTab extends StatefulWidget {
  final List<ProjectRoleCallss> roleCalls;

  TeamTab({this.roleCalls});

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<TeamTab> {

  List<ProjectRoleCallss> roles = new List();

  _buildContestList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: new ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: new EdgeInsets.only(bottom:16.0),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(index, roles[index]);
          },
          itemCount: roles.length > 3 ? 3 : roles.length,
        ),
      ),
    );
  }

  void setRoleData() {
    roles.clear(); //clear previous list
    // TODO: implement initState
    if (widget.roleCalls != null && widget.roleCalls.length > 0) {
      print("role_length ${widget.roleCalls.length}");
      for (var data in widget.roleCalls) {
        if (data.assignee != null) {
          roles.add(data);
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    setRoleData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        child: new Column(
          children: <Widget>[
            _buildContestList(),


          ],
        ),
      ),
    );
  }

  Widget buildItem(int index, ProjectRoleCallss like) {
    return Container(
      child: Container(

        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                  padding: new EdgeInsets.symmetric(vertical: 15.0),
                  child: IntrinsicHeight(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                            width: 37.0,
                            height: 37.0,
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Colors.transparent, width: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: getCachedNetworkImage(
                                  url:
                                  "${APIs.imageBaseUrl}${like.assignee
                                      .thumbnailUrl}",
                                  fit: BoxFit.cover),
                            )),
                        new SizedBox(
                          width: 5.0,
                        ),


                        like.role != null && like.role.iconUrl != null
                            ? getSvgNetworkImage(
                            url: like.role.iconUrl, size: 37.0)
                            : Container(),
                        /*  new SvgPicture.asset(
                          AssetStrings.imageEditing,
                          width: 37.0,
                          height: 37.0,
                          fit: BoxFit.cover,
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),*/
                        Expanded(
                          child: Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  like != null ? like.assignee.fullName : "",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: AssetStrings.lotoBoldStyle),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                new SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    new Text(
                                      like.role != null &&
                                          like.role.name != null ? like.role
                                          .name : "",
                                      style: new TextStyle(
                                          color: AppColors.kPrimaryBlue,
                                          fontSize: 13.0,
                                          fontFamily: AssetStrings
                                              .lotoSemiboldStyle),
                                    ),
                                    new Text(
                                      like.role != null &&
                                          like.role.category != null ? " (${like
                                          .role.category.name})" : "",
                                      style: new TextStyle(
                                          color: AppColors
                                              .kPlaceHolberFontcolor,
                                          fontSize: 13.0,
                                          fontFamily: AssetStrings
                                              .lotoRegularStyle),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Container(
                  height: 1.0,
                  color: AppColors.tabBackground,
                ),


                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      new CupertinoPageRoute(builder: (BuildContext context) {
                        return new TeamTabDetails(roleCalls: roles,);
                      }),
                    );
                  },
                  child: Offstage(
                    offstage: index == 2 && roles.length > 3 ? false : true,
                    child: Container(
                      margin: new EdgeInsets.only(top: 15.0),
                      child: new Center(
                          child: new Text(
                            "Show more", style: new TextStyle(
                              color: AppColors.kPrimaryBlue,
                              fontSize: 15.0,
                              fontFamily: AssetStrings.lotoBoldStyle),)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
