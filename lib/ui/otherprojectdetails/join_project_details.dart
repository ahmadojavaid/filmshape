import 'dart:collection';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/ProjectRoleCount.dart';
import 'package:Filmshape/Model/join_project/join_project_details_response.dart';
import 'package:Filmshape/Model/role_model.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/join_project/join_project_video.dart';
import 'package:Filmshape/ui/join_project/project_roles_bottom_sheet.dart';
import 'package:Filmshape/ui/statelesswidgets/user_role_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class JoinProjectDetails extends StatefulWidget {
  final int projectId;
  String previousTabHeading;
  final ValueChanged<Widget> fullScreenWidget;

  JoinProjectDetails(this.projectId,
      {this.previousTabHeading, this.fullScreenWidget});

  @override
  _JoinProState createState() => _JoinProState();
}

class _JoinProState extends State<JoinProjectDetails> {
  GlobalKey<JoinProjectVideoState> key = new GlobalKey<JoinProjectVideoState>();
  JoinProjectProvider provider;

  String _gennre = "";
  String _description = "";
  String locatopn = "";
  String _projectTitle = "";
  Notifier _notifier;

  //List<ProjectRoleCallss> list = new List();

  final List<ProjectRolesCount> finalRoleList = new List<ProjectRolesCount>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      hitProjectDetailsApi();
    });
  }

  @override
  void dispose() {
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify('action', widget.previousTabHeading);
    super.dispose();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  hitProjectDetailsApi() async {
    provider.setLoading();
    var response = await provider.projectDetails(context, widget.projectId);

    if (response is JoinProjectDetailsResponses) {
      _gennre = response.genre?.name ?? "";
      _description = response.description;
      locatopn = response.location;
      _projectTitle = response.title;
      setRolesData(response);
      key.currentState.setData(response); //set data to video screen
      _notifier?.notify('action', _projectTitle ?? ""); //update title

    } else {
      APIError error = response;
      showInSnackBar(error.error);
    }
  }

  Future<void> setRolesData(JoinProjectDetailsResponses response) async {
    finalRoleList.clear();
    LinkedHashMap roleMap = new LinkedHashMap<String, ProjectRolesCallsCount>();
    if (response.projectRoleCalls != null) {
      for (var data in response.projectRoleCalls) {
        var myTeamRole = data?.role?.name ?? "";
        var assignee = data?.assignee ?? "";
        print("role $myTeamRole assigne $assignee");
        //if any role assigned already just add to list
        if (assignee != null) {
          finalRoleList.add(new ProjectRolesCount(data: data, count: 1));
        } else {
          //check if same role already exists
          if (roleMap.containsKey(myTeamRole)) {
            ProjectRolesCallsCount roleData = roleMap[myTeamRole];
            roleData.count += 1; //increase the count for same role
          } else //not exists its new role
          {
            var projectRoleCallData =
                new ProjectRolesCount(data: data, count: 1);
            roleMap[myTeamRole] = projectRoleCallData;
            finalRoleList.add(projectRoleCallData);
          }
        }
      }
      setState(() {});
    }
  }

  Widget getAttributeItem(String title, String value, String image, int type) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            style: AppCustomTheme.myProfileAttributeHeadingJoinProject,
          ),
          new SizedBox(
            height: 5.0,
          ),
          Row(
            crossAxisAlignment: type == 0
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SvgPicture.asset(
                image,
                width: 15.0,
                height: 15.0,
              ),
              new SizedBox(
                width: 7.0,
              ),
              Expanded(
                child: new Text(
                  value != null ? value : "",
                  style: new TextStyle(fontSize: 16.0),
                  //style: AppCustomTheme.myProfileAttributeStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  VoidCallback backCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    _notifier = NotifierProvider.of(context); // to update home screen header

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: appBarBackButton(onTap: backCall),
            backgroundColor: Colors.white,
            body: new SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  JoinProjectVideo(widget.fullScreenWidget, key: key),
                  getAttributeItem(
                      "Project title", _projectTitle, AssetStrings.edit, 0),
                  getAttributeItem("Project type", "Short Film",
                      AssetStrings.ploject_type, 0),
                  getAttributeItem("Genre", _gennre, AssetStrings.paint, 0),
                  getAttributeItem("Location", locatopn, AssetStrings.place, 0),
                  getAttributeItem(
                      "Description", _description, AssetStrings.msg, 1),
                  Container(
                    margin: new EdgeInsets.only(left: 40.0, top: 40.0),
                    child: new Text(
                      "Team and vacancies",
                      style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontFamily: AssetStrings.lotoRegularStyle),
                    ),
                  ),
                  Container(
                    child: new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: new EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        return buildItem(index);
                      },
                      itemCount: finalRoleList.length,
                    ),
                  ),
                  new SizedBox(
                    height: 4.0,
                  )
                ],
              ),
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  //this bottom sheet to send request for not assigned roles
  void _sendRequestForRoleBottomSheet(String roleId) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: getScreenSize(context: context).height - 140,
                  child: JoinProjectBottomSheet(
                      roleId, widget.projectId.toString())));
        });
  }

  Widget buildItem(int index) {
    var data = finalRoleList[index].data;
    var count = finalRoleList[index].count;
    return InkWell(
      onTap: () {
        if (data.assignee == null) //check if no role is assigned
          _sendRequestForRoleBottomSheet(data.role.id.toString());
      },
      child: Container(
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.only(left: 40.0, right: 20.0),
                    padding: new EdgeInsets.symmetric(vertical: 15.0),
                    child: IntrinsicHeight(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          UserRoleImage(
                            userThumbnail:
                                "${APIs.imageBaseUrl}${data?.assignee?.thumbnailUrl ?? ""}",
                          ),
                          new SizedBox(
                            width: 5.0,
                          ),
                          new SvgPicture.network(
                            "${APIs.imageBaseUrl}${data?.role?.iconUrl ?? ""}",
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              padding: new EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    (data.assignee != null)
                                        ? "${data.assignee?.fullName ?? ""}"
                                        : "Vacant position: ${count.toString()}",
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
                                        data?.role?.name ?? "",
                                        style: new TextStyle(
                                            color: AppColors.kPrimaryBlue,
                                            fontSize: 13.0,
                                            fontFamily:
                                                AssetStrings.lotoSemiboldStyle),
                                      ),
                                      Expanded(
                                        child: new Text(
                                          "(${data?.role?.category?.name ?? ""})",
                                          style: new TextStyle(
                                              color: AppColors
                                                  .kPlaceHolberFontcolor,
                                              fontSize: 13.0,
                                              fontFamily: AssetStrings
                                                  .lotoRegularStyle),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
