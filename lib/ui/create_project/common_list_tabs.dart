import 'dart:collection';
import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/filmshape_firebase_group.dart';


import 'package:Filmshape/Model/projectresponse/project_response.dart';

import 'package:Filmshape/Model/role_model.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/Utils/singleton_cache_data.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/ChatList/Chat/group_chat.dart';
import 'package:Filmshape/ui/create_project/add_required_role.dart';
import 'package:Filmshape/ui/create_project/create_project_bottom_sheet.dart';
import 'package:Filmshape/ui/statelesswidgets/user_role_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'user_assigned_role_bottom_sheet.dart';

class CommonList extends StatefulWidget {
  final bool isRole;
  final String projectId;
  final ValueChanged<Widget> fullScreenCallBack;

  CommonList(this.projectId, this.fullScreenCallBack, {Key key, this.isRole})
      : super(key: key);

  @override
  RoleListState createState() => RoleListState();
}

class RoleListState extends State<CommonList> {
  final List<ProjectRolesCallsCount> myNewList =
      new List<ProjectRolesCallsCount>();

  List<ProjectRoleCalls> _projectRoleTeam = List();
  CreateProfileSecondProvider provider;
  FirebaseProvider firebaseProvider;

  Future<void> setRolesData(List<ProjectRoleCalls> myTeam) async {
    myNewList.clear();
    _projectRoleTeam = myTeam;
    LinkedHashMap roleMap = new LinkedHashMap<String, ProjectRolesCallsCount>();

    if (myTeam.length > 0) {
      for (var data in myTeam) {
        var myTeamRole = data.role.name;
        var assignee = data.assignee;
        //if any role assigned already just add to list
        if (assignee != null) {
          myNewList.add(new ProjectRolesCallsCount(data: data, count: 1));
        } else {
          //check if same role already exists
          if (roleMap.containsKey(myTeamRole)) {
            ProjectRolesCallsCount roleData = roleMap[myTeamRole];
            roleData.count += 1; //increase the count for same role
          } else //not exists its new role
          {
            var projectRoleCallData =
                new ProjectRolesCallsCount(data: data, count: 1);
            roleMap[myTeamRole] = projectRoleCallData;
            myNewList.add(projectRoleCallData);
          }
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileSecondProvider>(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: new Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Text(
                    "My Team",
                    style: AppCustomTheme.createProfileSubTitle,
                  ),
                ),
                Expanded(
                  child: new Center(
                    child: getHalfScreenProviderLoader(
                      status: firebaseProvider.getLoading(),
                      context: context,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _checkGroupExistAlready();
                  },
                  child: new Text(
                    "Go to group chat",
                    style: new TextStyle(
                        fontFamily: AssetStrings.lotoSemiboldStyle,
                        fontSize: 15.0,
                        color: AppColors.kPrimaryBlue),
                  ),
                ),
                new SizedBox(
                  width: 6.0,
                ),
                new Icon(Icons.arrow_forward,
                    size: 20.0, color: AppColors.kPrimaryBlue)
              ],
            ),
          ),
          new SizedBox(
            height: 25.0,
          ),
          InkWell(
              onTap: () {
                //if came from project detail scren
                if (widget.isRole != null) {
                  List<String> list = new List();
                  for (var item in _projectRoleTeam) {
                    list.add(item.role.name);
                  }
                  //Navigator.pop(context);
                  Navigator.push(context,
                      new CupertinoPageRoute(builder: (BuildContext context) {
                    return new AddRequiredRole(
                      widget.projectId,
                      widget.fullScreenCallBack,
                      myTeam: list,
                      type: 1,
                      isForEditRole: true,
                    );
                  }));
                }
                //while creating project go back to add role section
                else {
                  Navigator.pop(context, "add a role screen");
                }
              },
              child: buttonAddRole(context)),
          new SizedBox(
            height: 15.0,
          ),
        ]..addAll(new List.generate(myNewList?.length ?? 0, (index) {
            return buildItem(index, context);
          })),
      ),
    );
  }

  //callback to role count added for each section
  Future<ValueSetter> valueCallBackCount(int count) async {
    _hitAapi();
  }

  void _hitAapi() async {
    var response = await provider.getProjectDetails(widget.projectId, context);

    if (response is ProjectResponse) {
      await setRolesData(response.projectRoleCalls);
    } else {
      APIError apiError = response;
      print("error ${apiError.error}");
    }
  }

  Widget buildItem(int index, BuildContext context) {
    var data = myNewList[index].data;
    var count = myNewList[index].count;
    return InkWell(
      onTap: () {
        //if no assigne added in
        if (data.assignee == null) {
          Navigator.push(context,
              new CupertinoPageRoute(builder: (BuildContext context) {
            return new CreateProjectSecond(
                data.role.id,
                data.role.name,
                widget.projectId,
                valueCallBackCount,
                0,
                widget.fullScreenCallBack);
          }));
        }
        //if user assigned to a role
        else {
          _createProjectBottomSheet(context, data);
        }
      },
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
                      InkWell(
                          onTap: () {
                            //  goToProfile(context, data.assignee.id.toString(),data.assignee?.fullName??"");
                          },
                          child: UserRoleImage(
                            userThumbnail:
                                "${APIs.imageBaseUrl}${data?.assignee?.thumbnailUrl ?? ""}",
                          )),
                      new SizedBox(
                        width: 5.0,
                      ),
                      new SvgPicture.network(
                        "${APIs.imageBaseUrl}${data.role.iconUrl ?? ""}",
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
                              RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                // TextOverflow.clip // TextOverflow.fade
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: data?.role?.category?.name ?? "",
                                        style: TextStyle(
                                            color: AppColors.kPrimaryBlue,
                                            fontSize: 13,
                                            fontFamily: AssetStrings
                                                .lotoSemiboldStyle)),
                                    TextSpan(
                                        text: " (${data.role?.name ?? ""})",
                                        style: TextStyle(
                                            color:
                                                AppColors.kPlaceHolberFontcolor,
                                            fontSize: 13,
                                            fontFamily:
                                                AssetStrings.lotoRegularStyle)),
                                  ],
                                ),
                              )
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
    );
  }

  void _createProjectBottomSheet(
      BuildContext context, ProjectRoleCalls projectRoleCalls) async {
    var data = await showModalBottomSheet<String>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  child: UserAssignedToRoleBottomSheet(
                      valueCallBackCount, projectRoleCalls, widget.projectId)));
        });
  }

  void _checkGroupExistAlready() async {
    firebaseProvider.setLoading();
    var groupId=getProjectGroupId(provider.projectResponse.id.toString());
    var oldGroup = await firebaseProvider
        .getGroup(groupId);
    if (oldGroup is FilmShapeFirebaseGroup) {
      await firebaseProvider.getGroupFriends(
          userIds: oldGroup.groupMembersId, groupId: groupId);
      _moveToGroupChatScreen(oldGroup);
    } else {
      _createGroup();
    }
  }

  void _getGroup() async {
    firebaseProvider.setLoading();
    var groupId = getProjectGroupId(provider.projectResponse.id.toString());
    var oldGroup = await firebaseProvider.getGroup(groupId);
    if (oldGroup is FilmShapeFirebaseGroup) {
      await firebaseProvider.getGroupFriends(
          userIds: oldGroup.groupMembersId, groupId: groupId);
      _moveToGroupChatScreen(oldGroup);
    } else {
      //  showInSnackBar("No group found for given id");
    }
  }

  void _moveToGroupChatScreen(FilmShapeFirebaseGroup firebaseGroup) {
    SingletonCacheData singletonCacheData = SingletonCacheData();
    var userInfo = singletonCacheData.getUserInfo();
    var currentUserId = MemoryManagement.getuserId();


    var screen = GroupChat(
      filmShapeFirebaseGroup: firebaseGroup,
      currentUserId: currentUserId,
      currentUserName: userInfo.user.fullName ?? "",
      currentUserProfilePic: userInfo.user.thumbnailUrl ?? "",
      projectData: null,
    );
    //move to private chat screen
    widget.fullScreenCallBack(screen);
  }

  void _createGroup() async {
    var userId = MemoryManagement.getuserId();
    var group = FilmShapeFirebaseGroup(
        groupName: "test",
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        createdBy: userId,
        groupId: "",
        groupThumbnail: "",
       );
    var groupMembers = List<FilmShapeFirebaseGroupMember>();
    var groupMembersId = List<int>();
    var admin = FilmShapeFirebaseGroupMember(
        isAdmin: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isBlocked: false,
        userId: userId);
    groupMembersId.add(int.parse(userId));
    groupMembers.add(admin); //add admin to list
    for (var user in provider.projectResponse.team) {
      //because creator already in the list
      if (user.id.toString() == userId) {
        continue;
      }
      var member = FilmShapeFirebaseGroupMember(
          isAdmin: false,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          isBlocked: false,
          userId: user.id.toString());
      groupMembers.add(member); //add other group member in list
      groupMembersId.add(user.id); //save user id
    }
    group.groupTotalMembers = groupMembersId.length;
    group.groupMembersId = groupMembersId;
    group.lastMessage = "group created";
    group.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    if (groupMembers.length >= 1) {
      firebaseProvider.setLoading();
      await firebaseProvider.createGroupProject(group, groupMembers,
          getProjectGroupId((provider.projectResponse.id.toString())));
      //showInSnackBar("Group created successfully");
      _getGroup(); //move to chat screen
    } else {
      //  showInSnackBar("No Team members found!");
    }
  }
}

Widget buttonAddRole(BuildContext context) {
  return new Container(
    margin: new EdgeInsets.only(left: 40.0, right: 40.0),
    decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        color: AppColors.kPrimaryBlue),
    padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 14.0),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // new Image.asset(image,width: 18.0,height: 18.0),

        new Icon(
          Icons.person_add,
          color: Colors.white,
          size: 21.0,
        ),
        new SizedBox(
          width: 12.0,
        ),

        new Text(
          "Add a role",
          style: new TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontFamily: AssetStrings.lotoRegularStyle),
        ),
      ],
    ),
  );
}
